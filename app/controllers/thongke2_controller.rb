class Thongke2Controller < ApplicationController
  def index
    # Xử lý ngày lọc
    start_date = begin
      Date.parse(params[:start_date]) if params[:start_date].present?
    rescue ArgumentError
      nil
    end || Date.today.beginning_of_month

    end_date = begin
      Date.parse(params[:end_date]) if params[:end_date].present?
    rescue ArgumentError
      nil
    end || Date.today

    # Lấy dữ liệu và tính toán
    @orders = Donhang.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    @order_chart_data = @orders.group_by_day(:created_at).count.map do |date, count|
      { date: date.strftime("%Y-%m-%d"), count: count }
    end

    @filtered_orders = Donhang.where(ngaydathang: start_date.beginning_of_day..end_date.end_of_day).where(trangthai: "Đã nhận")

    @doanh_so = 0
    @doanh_thu = 0
    @chi_phi = 0

    # Tối ưu tìm sản phẩm
    sanpham_cache = Sanpham.all.index_by(&:ten)

    # Khởi tạo hash để theo dõi số lượng bán ra
    sold_quantities = Hash.new(0)

    @filtered_orders.each do |order|
      next unless order.thongtinsanpham.present?

      products = parse_products(order.thongtinsanpham)
      products.each do |product|
        sanpham = sanpham_cache[product[:ten]]
        next unless sanpham

        soluong = product[:soluong]
        @doanh_so += soluong * sanpham.gia
        @chi_phi += soluong * sanpham.gianhap

        # Cộng dồn số lượng bán vào hash
        sold_quantities[product[:ten]] += soluong
      end
    end

    @doanh_thu = @doanh_so
    @loi_nhuan = @doanh_thu - @chi_phi

    # Thống kê sản phẩm bán chạy
    @top_selling_products = sold_quantities.map do |ten, soluong_ban|
      sanpham = sanpham_cache[ten]
      next unless sanpham

      {
        ten: ten,
        soluong_ban: soluong_ban,
        ton_kho: sanpham.soluong,
        gia: sanpham.gia,
        gianhap: sanpham.gianhap,
        donvi: sanpham.donvi,
        loinhuan: (sanpham.gia - sanpham.gianhap) * soluong_ban
      }
    end.compact.sort_by { |product| -product[:soluong_ban] }.first(5)

    # Thống kê sản phẩm bị lỗ
    @loss_products = sold_quantities.map do |ten, soluong_ban|
      sanpham = sanpham_cache[ten]
      next unless sanpham

      doanh_thu = soluong_ban * sanpham.gia
      chi_phi = soluong_ban * sanpham.gianhap
      next if doanh_thu >= chi_phi # Chỉ lấy sản phẩm bị lỗ

      {
        ten: ten,
        soluong_ban: soluong_ban,
        doanh_thu: doanh_thu,
        chi_phi: chi_phi,
        ton_kho: sanpham.soluong,
        donvi: sanpham.donvi,
        lo: chi_phi - doanh_thu
      }
    end.compact
    

    respond_to do |format|
      format.html
      format.json do
        render json: {
          doanh_so: @doanh_so,
          doanh_thu: @doanh_thu,
          chi_phi: @chi_phi,
          loi_nhuan: @loi_nhuan,
          chart_data: @order_chart_data,
          top_selling_products: @top_selling_products,
          loss_products: @loss_products
        }
      end
    end
  end

  

  private

  # Hàm tách thông tin sản phẩm từ chuỗi
  def parse_products(thongtinsanpham)
    products = []
    thongtinsanpham.split(",").each do |product_info|
      match_data = product_info.strip.match(/^(?<ten>.+?) (?<soluong>\d+) (kg|bao|thùng)$/)
      next unless match_data

      products << {
        ten: match_data[:ten],
        soluong: match_data[:soluong].to_i
      }
    end
    products
  end
end
