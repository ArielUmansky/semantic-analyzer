require "rails_helper"
require 'sucker_punch/testing/inline'
require "requests/sugar"
require_all 'app/models/'

RSpec.describe "Job", :type => :model do

  describe "Asynchronous jobs" do

    let(:job) { AnalyzerJob.new }

    subject { job.perform(corpus, algorithm, metadata, url) }

    let(:algorithm) { Analyzer::KMEANS }

    let(:url) { "an_url"}

    before(:each) do
      allow(Requests).to receive(:post)
    end

    let(:first_document_hash) do
      {document: "one text", user_info: SecureRandom.uuid}
    end

    let(:second_document_hash) do
      {document: "another text", user_info: SecureRandom.uuid}
    end

    let(:corpus) { [first_document_hash, second_document_hash]}

    let(:metadata) do
      {nmb_of_centroids: 2}
    end

    context "when the params are correct" do

      it "should make a post to the given url with the corpus clustered" do
        subject
        expect(Requests).to have_received(:post).with(url, data: { result_set: { result: [ { grouped_documents: [first_document_hash]}, { grouped_documents: [second_document_hash]} ]},
                                                                               algorithm: algorithm }.to_json, headers: {"Content-type" => "application/json"} )
      end

    end

    context "when there is some kind of error" do

      shared_examples :fails_correctly do |exception|
        it "should make a post to the given url describing the error" do
          subject
          expect(Requests).to have_received(:post).with(url, data: {error: exception}.to_json, headers: {"Content-type" => "application/json"})
        end
      end

      context "when there is more clusters than documents" do

        let(:metadata) do
          {nmb_of_centroids: 4}
        end

        include_examples :fails_correctly, KMeans::TOO_MANY_CENTROIDS_EXCEPTION

      end

      context "when there is just one document in the corpus" do

        let(:corpus) { [first_document_hash] }

        include_examples :fails_correctly, KMeans::MISSING_DOCUMENTS_EXCEPTION

      end

      context "when there are repeated documents" do

        let(:corpus) { [first_document_hash, first_document_hash] }

        include_examples :fails_correctly, KMeans::REPEATED_DOCUMENTS_EXCEPTION

      end

    end

  end

end