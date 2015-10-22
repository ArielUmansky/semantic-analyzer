require "rails_helper"
require 'webmock/rspec'
require 'sucker_punch/testing/inline'

RSpec.describe "Analyzer", :type => :request do

  describe "POST /analyzer" do

    subject { post("/analyzer", req_params, nil) }

    let(:url) { "https://www.campanarium.com.ar/semantic_analyzer_result" }

    context "when there are problems with the request" do

      before {
        stub_request(:any, url)
      }

      shared_examples :fails_correctly do

        it "returns unprocessable entity" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns a declarative error message" do
          subject
          expect(JSON.parse(response.body)["error"]).to eq error_message
        end
      end

      context "when the body is empty" do
        let(:req_params) { nil }
        let(:error_message){ "param is missing or the value is empty: corpus" }


        include_examples :fails_correctly

      end

      context "when the there is a body but there is no corpus data" do
        let(:req_params) do
          {
              body: { foo: "foo" }
          }
        end
        let(:error_message){ "param is missing or the value is empty: corpus" }

        include_examples :fails_correctly

      end

      context "when the there is a body but the algorithm configured is not supported" do
        let(:req_params) do
          {
              body: { corpus: ["foo"],
                      algorithm: "foo" }
          }
        end
        let(:error_message){ "param is missing or the value is empty: corpus" }

        include_examples :fails_correctly

      end

      context "when kmeans is the algorithm selected" do

        context "when the required metadata is missing" do
          let(:req_params) do
            {
                body: { corpus: ["foo"],
                        algorithm: Analyzer::KMEANS }
            }
          end
          let(:error_message){ "param is missing or the value is empty: corpus" }

          include_examples :fails_correctly

        end

      end

      context "when there are documents repeated" do
        let(:req_params) do
          {
              corpus: corpus,
              metadata: {
                  nmb_of_centroids: 2
              }
          }
        end

        let(:corpus) { [ { document: "foo", category: "politics", keywords: ["foo"]},
                         { document:"foo", category: "sports", keywords: ["bar"]} ] }

        let(:error_message){ KMeans::REPEATED_DOCUMENTS_EXCEPTION }

        include_examples :fails_correctly

      end

      context "when there is only one document in the request" do

        let(:req_params) do
          {
              corpus: corpus,
              metadata: {
                  nmb_of_centroids: 2
              }
          }
        end

        let(:corpus) { [ {document: "foo", category: "politics", keywords: ["foo"]} ] }

        let(:error_message){ KMeans::MISSING_DOCUMENTS_EXCEPTION }

        include_examples :fails_correctly

      end

    end

    context "when the request is correct" do

      shared_examples :returns_ok_as_soon_as_possible do

        it "returns status ok" do
          subject
          expect(response).to have_http_status(:ok)
        end

        it "informs where the analyzer will post the result" do
          subject
          expect(JSON.parse(response.body)["info"].include?(url)).to be true
        end
      end

      let(:req_params) do
        {
            corpus: corpus,
            algorithm: algorithm,
            metadata: {
                nmb_of_centroids: 2
            },
            url: url
        }
      end

      let(:corpus) { [ { document: "foo", category: "politics", keywords: ["foo"]},
                       { document:"bar", category: "sports", keywords: ["bar"]} ] }

      let(:algorithm) {Analyzer::KMEANS }

      before {
        stub_request(:post, url)
      }

      include_examples :returns_ok_as_soon_as_possible

    end

  end

end
