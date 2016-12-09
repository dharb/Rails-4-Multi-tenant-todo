module Request
  
  module SubdomainHelpers
    def within_subdomain(subdomain)
      request.host = subdomain ? "#{subdomain}.lvh.me" : "lvh.me"
    end

    def within_main_domain
      within_subdomain nil
    end
  end

  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module HeadersHelpers
    def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.todo.v#{version}"
    end

    def api_response_format(format = Mime::JSON)
      request.headers['Accept'] = "#{request.headers['Accept']},#{format}"
      request.headers['Content-Type'] = format.to_s
    end

    def include_default_accept_headers
      api_header
      api_response_format
    end

    def auth_header(token)
      request.headers['Authorization'] =  token
    end
  end
end
