require "rails_helper"

RSpec.describe "Analyzer", :type => :request do

  describe "POST /analyzer" do

    subject { post("/analyzer", req_params, nil) }

    context "when there are problems with the request" do

      context "when the body is empty" do
        let(:req_params) { nil }

        it "returns bad request" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

      end

      context "when the there is a body but there is no corpus data" do
        let(:req_params) do
          {
              body: { foo: "foo" }
          }
        end

        it "returns bad request" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

      end


      context "when the there is a body but the algorithm configured is not supported" do
        let(:req_params) do
          {
              body: { corpus: ["foo"],
                      algorithm: "foo" }
          }
        end

        it "returns bad request" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

      end

      context "when kmeans is the algorithm selected" do

        context "when the required metadata is missing" do
          let(:req_params) do
            {
                body: { corpus: ["foo"],
                        algorithm: Analyzer::KMEANS }
            }
          end

          it "returns bad request" do
            subject
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

      end

    end

    context "when request is correct" do
      let(:req_params) do
        {
            body: {
                corpus: corpus,
                algorithm: algorithm,
                metadata: {
                  nmb_of_centroids: 4
                }
            }
        }
      end

      let(:corpus) { ["foo", "bar", "foo2", "foo bar", "etc etc", "bla etc", "deberia andar siempre esto por fa", "es jodido eh esto bla etc"] }
      let(:algorithm) {Analyzer::KMEANS }

      it "returns http status ok" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "returns a result_set" do
        subject
        expect(JSON.parse(response.body)["result_set"]).to be_a(Array)
      end

      it "returns the algorithm used" do
        subject
        expect(JSON.parse(response.body)["algorithm"]).to eq(Analyzer::KMEANS)
      end

      context "when algorithm is not present" do
        let(:algorithm) { nil }

        it "returns http status ok" do
          subject
          expect(response).to have_http_status(:ok)
        end

        it "assumes kmeans" do
          subject
          expect(JSON.parse(response.body)["algorithm"]).to eq(Analyzer::KMEANS)
        end

      end

    end

  end

end