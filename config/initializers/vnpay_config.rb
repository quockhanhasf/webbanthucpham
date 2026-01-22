# config/initializers/vnpay_config.rb
VNPAY_CONFIG = {
  vnp_url: "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html", # URL cổng thanh toán sandbox
  vnp_tmncode: "ZNK9XK98", # Mã website của bạn
  vnp_hashsecret: "9F5J0K7DR1NNGJDTDM7P93RHLL14TPT2", # Khóa bí mật
  vnp_return_url: "http://localhost:3000/vnpay_return" # URL xử lý kết quả thanh toán
}
