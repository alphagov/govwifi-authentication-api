describe App do
  describe "visiting /authorize" do
    let(:username) { "abcdef" }
    let(:client_mac) { "ee-ee-ee-ee-ee" }
    let(:ap_mac) { "ff-ff-ff-ff-ff" }
    let(:ap_ip_address) { "192.168.1.100" }
    let(:ap_aruba_name) { "hallway-1" }
    let(:ap_meraki_name) { "hallway-2" }

    after do
      DB[:userdetails].truncate
    end

    context "as the Health user" do
      let(:username) { "HEALTH" }

      before do
        DB[:userdetails].insert(username: username, password: "TestUserPassword")
        get "/authorize/user/#{username}"
      end

      it "responds with 200 to a GET" do
        expect(last_response).to be_ok
      end

      it "responds with password in the body" do
        expect(last_response.body).to eq('{"control:Cleartext-Password":"TestUserPassword"}')
      end
    end

    context "as a non-existent user" do
      before { get "/authorize/user/not-a-user" }

      it "responds with 404 to a GET" do
        expect(last_response.status).to eq(404)
      end

      it "responds with an empty string" do
        expect(last_response.body).to eq("")
      end
    end

    context "with extra url parameters" do
      let(:url) { "/authorize/user/#{username}/mac/#{client_mac}/ap/#{ap_mac}/site/#{ap_ip_address}/apg/#{ap_aruba_name}/mdn/#{ap_meraki_name}" }

      context "as a valid user" do
        before do
          DB[:userdetails].insert(username: username, password: "FooBarBaz")
          get url
        end

        it "responds with password in the body" do
          expect(last_response.body).to eq('{"control:Cleartext-Password":"FooBarBaz"}')
        end
      end

      context "as an invalid user" do
        let(:username) { "invalid-user" }
        before { get url }

        it "responds with an empty string" do
          expect(last_response.body).to eq("")
        end
      end
    end

    context "with multiple connections to mysql" do
      let(:url) { "/authorize/user/#{username}" }

      before do
        DB[:userdetails].insert(username: username, password: "FooBarBaz")

        200.times do
          get url
        end
      end

      it "does not fall over" do
        expect(last_response).to be_ok
      end
    end
  end
end
