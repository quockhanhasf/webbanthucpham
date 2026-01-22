# config/initializers/currency_format.rb

module CurrencyFormatter
  def self.format_vnd(amount)
    ActiveSupport::NumberHelper.number_to_currency(amount,
    unit: "VNĐ",
    separator: ",",
    delimiter: ".",
    format: "%n %u",
    precision: 0 # Không hiển thị phần thập phân
  )
  end
end
