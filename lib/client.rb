module InternetMarke
  class Client
    attr_reader :authToken, :shoppingOrderId, :apiVersion
    mattr_accessor :client_id, :client_secret, :username, :password

    @@auth_type = "client_credentials"
    @@api_version = "v1.1.14"

    @@auth_url = "https://api-eu.dhl.com/post/de/shipping/im/v1/user"
    @@api_url = "https://api-eu.dhl.com/post/de/shipping/im/v1/"
    @@profile_url = "https://api-eu.dhl.com/post/de/shipping/im/v1/user/profile"
    @@put_wallet_url = "https://api-eu.dhl.com/post/de/shipping/im/v1/app/wallet?amount="
    @@get_wallet_url = "https://api-eu.dhl.com/post/de/shipping/im/v1/app/wallet?amount=0"
    @@init_shopping_cart_url = "https://api-eu.dhl.com/post/de/shipping/im/v1/app/shoppingcart"
    @@create_order_png_url = "https://api-eu.dhl.com/post/de/shipping/im/v1/app/shoppingcart/png"
    @@create_order_pdf_url = "https://api-eu.dhl.com/post/de/shipping/im/v1/app/shoppingcart/pdf"

    def initialize(client_id, client_secret, username, password)
      @client_id = client_id
      @client_secret = client_secret
      @username = username
      @password = password

      self.check_api_version
      if @apiVersion == @@api_version
        @authToken = self.generate_auth_token
      else
        raise "selected api version #{@apiVersion} is not supported"
      end
    end

    def get_expected_api_version
      return @@api_version
    end

    def check_api_version
      url = URI(@@api_url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      @request = http.request(request)
      @response = JSON.parse @request.read_body

      @apiVersion = @response["amp"]["version"]
    end

    def generate_auth_token
      url = URI(@@auth_url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["content-type"] = 'application/x-www-form-urlencoded'
      request["Content-Length"] = '0'
      request["charset"] = 'utf-8'

      bodyParams = [["grant_type", @@auth_type], ["client_id", @client_id], ["client_secret", @client_secret], ["username", @username], ["password", @password]]
      request.body = URI.encode_www_form(bodyParams)

      @request = http.request(request)
      @response = JSON.parse @request.read_body
      if @response
        if @response["access_token"]
          return @response["access_token"]
        else
          raise "authorization failed. no access token generated"
        end
      else
        raise "authorization failed"
      end
    end

    def get_profile
      if @authToken
        url = URI(@@profile_url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["Authorization"] = "Bearer " + @authToken

        @request = http.request(request)

        return JSON.parse @request.read_body
      end
    end

    def init_shopping_cart
      if @authToken
        url = URI(@@init_shopping_cart_url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["Authorization"] = "Bearer " + @authToken
        request["Content-Length"] = '0'

        @request = http.request(request)
        @response = JSON.parse @request.read_body

        if @response["shopOrderId"]
          @shoppingOrderId = @response["shopOrderId"]
        else
          raise "no shopOrderId generated"
        end
      end
    end

    def put_wallet(amount)
      if @authToken
        url = URI(@@put_wallet_url + amount.to_s)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Put.new(url)
        request["Authorization"] = "Bearer " + @authToken

        @request = http.request(request)

        return JSON.parse @request.read_body
      end
    end

    def get_wallet
      if @authToken
        url = URI(@@get_wallet_url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Put.new(url)
        request["Authorization"] = "Bearer " + @authToken

        @request = http.request(request)

        return JSON.parse @request.read_body
      end
    end

    def buy(quantity, product, price)
      self.init_shopping_cart

      if @authToken && @shoppingOrderId
        url = URI(@@create_order_png_url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["content-type"] = 'application/json'
        request["Authorization"] = "Bearer " + @authToken
        request["Content-Length"] = '0'

        positions = Array.new
        position = {
          "productCode": product,
          "imageID": 0,
          "additionalInfo": "",
          "voucherLayout": "ADDRESS_ZONE",
          "positionType": "AppShoppingCartPosition"
        }

        quantity.times do |i|
          positions.push(position)
        end

        @amount = (price * 100).to_i
        bodyParams = {
          "type": "AppShoppingCartPNGRequest",
          "shopOrderId": @shoppingOrderId,
          "total": quantity * @amount,
          "createManifest": true,
          "dpi": "DPI300",
          "optimizePNG": true,
          "positions": positions
        }

        request.body = bodyParams.to_json
        @request = http.request(request)

        return JSON.parse @request.read_body
      end
    end
  end
end