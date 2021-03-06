require 'active_support/concern'

module ServerSupport

  extend ActiveSupport::Concern
  include Rack::Test::Methods

  included do
    before do
      current_session.header('Accept', 'application/json, text/javascript, */*; q=0.01')
    end
  end

  def app
    Hobson::Server
  end

  def response
    last_response
  end

  def response_data
    raise response.errors if response.errors != ""
    response.body == '' ? nil : JSON.parse(response.body)
  end

  def view_response!
    File.open('/tmp/error.html','w'){|f| f.write(response.body) }; `open /tmp/error.html`
  end

  def response_should_equal expected_response
    if expected_response.nil?
      response.body.should be_blank
    else
      response_data.should == JSON.parse(expected_response.to_json)
    end
  end

  def e string
    URI.encode(string).gsub('/', '%2F')
  end

  def j data
    JSON.parse(data.to_json)
  end

  def encode_origin origin
    origin.gsub('/', '%2F')
  end

  def project_path project
    "/projects/#{encode_origin(project.origin)}"
  end

  module ClassMethods
    def freeze_time!

      let!(:now){ Time.at(1347801214) }

      before do
        Time.should_receive(:now).any_number_of_times.and_return{ now }
      end

    end
  end

end
