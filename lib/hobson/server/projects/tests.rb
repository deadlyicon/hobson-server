class Hobson::Server

  namespace '/projects/:project_origin/tests' do

    # index
    get do
      respond_with :'projects/tests/index', :tests => project_tests
    end

  end

end
