require "net/http"
require "json"

class PaymentsController < ApplicationController
  def thanh_toan
    amount = params[:amount] || "50000"

    # Parameters
    access_key = "F8BBA842ECF85"
    secret_key = "K951B6PE1waDMi640xX08PD3vg6EkVlz"
    partner_code = "MOMO"
    order_info = "pay with MoMo"
    redirect_url = payment_success_url # URL quay về khi thanh toán xong
    ipn_url = payment_webhook_url     # URL cho webhook (nếu có)
    order_id = SecureRandom.uuid
    request_id = SecureRandom.uuid
    extra_data = ""
    request_type = "payWithMethod"
    lang = "vi"
    auto_capture = true

    # Raw signature string
    raw_signature = "accessKey=#{access_key}&amount=#{amount}&extraData=#{extra_data}&ipnUrl=#{ipn_url}&orderId=#{order_id}&orderInfo=#{order_info}&partnerCode=#{partner_code}&redirectUrl=#{redirect_url}&requestId=#{request_id}&requestType=#{request_type}"
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret_key, raw_signature)

    # JSON request body
    json_request = {
      partnerCode: partner_code,
      requestId: request_id,
      redirectUrl: redirect_url,
      amount: amount,
      orderId: order_id,
      orderInfo: order_info,
      ipnUrl: ipn_url,
      lang: lang,
      autoCapture: auto_capture,
      extraData: extra_data,
      requestType: request_type,
      signature: signature
    }

    # MoMo API endpoint
    uri = URI.parse("https://test-payment.momo.vn/v2/gateway/api/create")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request.add_field("Content-Type", "application/json")
    request.body = json_request.to_json

    response = http.request(request)
    result = JSON.parse(response.body)

    if result["payUrl"]
      redirect_to result["payUrl"], allow_other_host: true
    else
      flash[:alert] = "Thanh toán thất bại: #{result['message']}"
      redirect_to root_path
    end
  end

  def payment_success
    result_code = params[:resultCode] # 0: Thành công, các mã khác là lỗi

    if result_code.to_i == 0
      flash[:notice] = "Thanh toán thành công!"
      payment_status = "success"
    else
      flash[:alert] = "Thanh toán thất bại hoặc bị hủy."
      payment_status = "failed"
    end

    # Lấy lại danh sách sản phẩm đã chọn từ session
    selected_products = session[:selected_products] || []

    # Giữ lại sản phẩm đã chọn trong session
    session[:selected_products] = selected_products

    # Chuyển hướng về trang order và truyền trạng thái thanh toán
    redirect_to order_path(payment_status: payment_status)
  end
end
