require 'rails_helper'
require 'require_all'

require_all 'app/models/'

RSpec.describe DocumentVector do

  let(:noticia) {  "Boca venció a River por 5 a 0 en el clásico de verano"}
  let(:noticia2) { "Tras la goleada, los afiches de Boca gastando a las gallinas, empapelaron la ciudad"}

  describe "#initialize" do

    subject { DocumentVector.new(document) }

    context "when data input data is invalid" do

      # I prefer repeating some code instead of using shared examples. I simply hate them.

      let(:document) { nil }

      context "when input data is empty" do

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

      context "when input data isn't a string" do

        let(:document) { ["some_foo_param"] }

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

    end

    context "when input data is valid" do

      let(:document) { noticia }

      let(:document_vector) { subject }

      it "sets the content" do
        expect(document_vector.content).to eq(noticia)
      end

    end

    context "when there is a category passed in the constructor" do

      subject { DocumentVector.new(document, category: category) }

      let(:document) { noticia }

      context "when category isn't a string" do
        let(:category) { 123 }
        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION) #TODO: Verify this clause. The exception's class is not being tested (I can change the class and the test will still be green)
        end
      end

      context "when category is a string" do
        let(:category) { "a_string" }
        let(:document_vector) { subject }
        it "sets the category" do
          expect(document_vector.category).to eq(category)
        end
      end
    end

    context "when there are keywords passed in the constructor" do

      subject { DocumentVector.new(document, keywords: keywords) }

      let(:document) { noticia }

      context "when keywords are not an array" do
        let(:keywords) { 123 }
        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end
      end

      context "when keywords are not an array of strings" do
        let(:keywords) { [123, "foo"] }
        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end
      end

      context "when keywords are an array of strings" do
        let(:keywords) { ["a_string", "another_string"] }
        let(:document_vector) { subject }
        it "sets the category" do
          expect(document_vector.keywords).to eq(keywords)
        end
      end
    end

  end

  describe "#term_frequency" do

    subject { document_vector.term_frequency(term) }

    let(:document_vector) { DocumentVector.new(noticia) }

    context "when input data is incorrect" do

      context "when term is nil" do

        let(:term) { nil }

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

      context "when term is not a string" do

        let(:term) { 123 }

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

    end

    context "when input data is correct" do

      let(:term) { "Boca" }

      it "calculates the term frequency correctly" do
        expect(subject).to eq(1.fdiv(13) * KMeans::NAME_WEIGHT_HEURISTIC)
      end

    end

  end

  describe "#contains_term?" do

    subject { document_vector.contains_term?(term) }

    let(:document_vector) { DocumentVector.new(noticia) }

    context "when input data is incorrect" do

      context "when term is nil" do

        let(:term) { nil }

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

      context "when term is not a string" do

        let(:term) { 123 }

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

    end

    context "when input data is correct" do

      context "when the term exists" do

        let(:term) { "Boca" }

        it "returns true" do
          expect(subject).to be(true)
        end

      end

      context "when the term doesn't exists" do

        let(:term) { "Foo" }

        it "returns false" do
          expect(subject).to be(false)
        end

      end

    end

  end

  describe "#same_vector_space?" do

    let(:corpus) { Corpus.new(corpus_arguments)}

    let(:document_vector1) { corpus.document_vector_list.first }
    let(:document_vector2) { corpus.document_vector_list.second }

    subject { document_vector1.same_vector_space?(document_vector2) }

    context "when vector spaces are different" do

      let(:corpus_arguments) { [noticia, noticia2] }

      it "returns false" do
        expect( subject ).to be false
      end

    end

    context "when vector spaces are the same" do

      let(:corpus_arguments) { [noticia, noticia] }

      it "returns true" do
        expect( subject ).to be true
      end

    end
  end

end
