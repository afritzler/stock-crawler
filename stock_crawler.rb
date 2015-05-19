# stock_quote.rb

require "stock_quote"

symbols = ["RDSA.AS","CLM15.NYM","EURUSD=X"]

bid_old = [ 0.0, 0.0, 0.0 ]
ask_old = [ 0.0, 0.0, 0.0 ]

delay = 30
training_output = 'data/training_data_dummy.csv'

def delta(old_price, new_price)
  if (new_price - old_price) > 0
    return 1
  else
    return 0
  end
end

loop do
  line = ""
  p "Fetching stock quotes"
  stocks = StockQuote::Stock.quote(symbols)
  stocks.each_with_index do |stock, index|
    if bid_old[index] == 0.0 or ask_old[index] == 0.0
      p "Not initialized old values ... taking the first one"
      unless stock.bid.nil?
        bid_old[index] = stock.bid
      end
      unless ask_old.nil?
        ask_old[index] = stock.ask
      end
      next
    end
    line += "," << bid_old[index].to_s << "," << stock.bid.to_s << "," << delta(bid_old[index],stock.bid).to_s << "," << ask_old[index].to_s << "," << stock.ask.to_s << "," << delta(ask_old[index],stock.ask).to_s
    bid_old[index] = stock.bid
    ask_old[index] = stock.ask
  end
  if !line.empty?
    p "Writing entry to file"
    data = Time.now.getutc.to_s << line
    p data
    open(training_output, 'a') do |f|
      f << data << "\n"
    end
  end
  p "Sleeping until the next run for " << delay.to_s << " seconds."
  sleep delay
end
