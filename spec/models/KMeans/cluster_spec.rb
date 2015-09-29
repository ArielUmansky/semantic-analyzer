require 'rails_helper'
require 'require_all'

require_all 'app/models/'

RSpec.describe Cluster do

  let(:noticia1) { "Boca venció a River por 5 a 0 en el clásico de verano" }
  let(:noticia2) { "Tras la goleada, los afiches de Boca gastando a las gallinas, empapelaron la ciudad" }

  let(:corpus){ Corpus.new([{document: noticia1}, {document: noticia2}])}

  let(:document_vector1) { corpus.document_vector_list.first }
  let(:document_vector2) { corpus.document_vector_list.second }

  let(:cluster) { Cluster.new }

  let(:amount_of_different_terms) { 14 }

  before do
    cluster.add_document(document_vector1)
    cluster.add_document(document_vector2)
  end

  shared_examples :generates_a_correct_sized_array do
    it "generates a correct sized array" do
      expect(subject.count).to eq(amount_of_different_terms)
    end
  end

  describe "#array_of_vector_spaces_by_position" do

    subject { cluster.array_of_vector_spaces_by_position }

    it_behaves_like :generates_a_correct_sized_array

    it "each position should be an array of two elements" do
      subject.each do |array|
        expect(array.count).to eq(2)
      end
    end

    #This is tf-idf for "Boca" and "venció" for the first and for the second document
    it "groups the vector spaces for each position" do
      expect(subject.first).to match_array([0.0, 0.0])
      expect(subject.second).to match_array([0.09902102579427789, 0.0])
    end

  end


  describe "#calculate_mean_vector_space" do

    subject { cluster.calculate_mean_vector_space }

    let(:array_of_vector_spaces_by_position) { cluster.array_of_vector_spaces_by_position}
    let(:avg_first_position) { 0.0 }
    let(:avg_second_position) { 0.049510512897138946 }

    it_behaves_like :generates_a_correct_sized_array

    it "each position should be a tf-idf value" do
      subject.each do |value|
        expect(value).to be_a(Float)
      end
    end

    #This is tf-idf for "Boca" and "venció" for the first and for the second document
    it "calculates the average for each position" do
      result = subject
      expect(result.first).to eq(avg_first_position)
      expect(result.second).to eq(avg_second_position)

    end

  end

  describe "#same_centroid?" do

    before do
      corpus = Corpus.new([{document: noticia1}, {document: noticia2}])
      document_vector1 = corpus.document_vector_list.first
      document_vector2 = corpus.document_vector_list.second
    end


    let(:cluster1) { Cluster.new }
    let(:cluster2) { Cluster.new }


    subject { cluster1.same_centroid?(cluster2) }

    context "when cluster's centroids are different" do

      it "returns false" do
        cluster1.add_document document_vector1
        cluster2.add_document document_vector2
        expect( subject ).to be false
      end


    end

    context "when cluster's centroids are the same" do

      it "returns true" do
        cluster1.add_document document_vector1
        cluster1.add_document document_vector2

        cluster2.add_document document_vector1
        cluster2.add_document document_vector2

        expect( subject ).to be true
      end

    end

    context "when the documents are the same but the order is different" do
      it "returns false" do
        cluster1.add_document document_vector1
        cluster1.add_document document_vector2

        cluster2.add_document document_vector2
        cluster2.add_document document_vector1

        expect( subject ).to be false
      end
    end

  end
end
