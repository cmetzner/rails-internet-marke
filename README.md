# Rails Internet Marke

Gem for use Deutsche Post REST Api in Ruby - Deutsche Post Api https://developer.dhl.com/api-reference/deutsche-post-internetmarke-post-paket-deutschland#get-started-section/

## Requirements
* DHL Developer account (https://developer.dhl.com)
  * API Key --> Client::client_id
  * API Secret --> Client::client_secret
* credentials for Deutsche Post Portokasse (https://portokasse.deutschepost.de)
  * email --> Client::username
  * password --> Client::password

## Functionality
* Get information about the used REST Api version.
* Get authorization token.
* Authenticate and retrieve authorized user's data for shop.
* Charge users wallet
* Initializes a shopping cart and returns the shopOrderId.
* Checkouts of the PNG shopping cart.

## Installation
Add this line to your application's Gemfile:

    gem 'rails-internet-marke'

And then execute:

    $ bundle install

Add this line to your config/application.rb:

    require 'internet_marke'

## Usage

init api client
  ```ruby
  client = InternetMarke::Client.new(client_id, client_secret, username, password)
  ```

### profile information
  ```ruby
  client.get_profile()
  ```
  ```ruby
=> {"ekp"=>"************", "company"=>nil, "title"=>nil, "invoiceType"=>"PAPER", "invoiceFrequency"=>"DECADE", "mail"=>"********@dhldp-test.de", "firstname"=>"Max", "lastname"=>"Tester 1045", "street"=>"Teststraße", "houseNo"=>"1045", "zip"=>"11045", "city"=>"ZTEST_Ort_001045", "country"=>"DEU", "phone"=>"12341045", "pobox"=>nil, "poboxZip"=>nil, "poboxCity"=>nil}
  ```

### call wallet amount
  ```ruby
  client.get_wallet
  ```
  ```ruby
=> {"shopOrderId"=>"1161167596", "walletBalance"=>0}
  ```

### charge wallet with 10€
  ```ruby
  client.put_wallet(1000)
  ```
  ```ruby
=> {"shopOrderId"=>"1161167596", "walletBalance"=>1000}
  ```

### buy standard postage mark for 0.85€
  ```ruby
  client.buy(1, 1, 0.85)
  ```
  ```ruby
=> {"type"=>"CheckoutShoppingCartAppResponse", "link"=>"https://internetmarke.deutschepost.de/PcfExtensionWeb/document?keyphase=0&data=ihiNb0veRtmVX1%2BQXd0BYshw8JiUVoXPh4T0fPzHH4Uy%2BieL%2FIDYPo45KmWcekPN", "manifestLink"=>"https://internetmarke.deutschepost.de/PcfExtensionWeb/document?keyphase=0&data=ihiNb0veRtmVX1%2BQXd0BYuum2TjxCgx0", "shoppingCart"=>{"shopOrderId"=>"1161167602", "voucherList"=>[{"voucherId"=>"A005C2ADD500000041EE", "trackId"=>nil}]}, "walletBallance"=>915}
  ```

# LICENSE
rails-internet-marke is licensed under the MIT license, see the [LICENSE](LICENSE.txt) file for details. 

Pull requests are welcome!