require 'rails_helper'
require 'require_all'

require_all 'app/models/'

RSpec.describe DocumentVector do

  let(:noticia) {  "Boca venció a River por 5 a 0 en el clásico de verano"}

  describe "#initialize" do

    subject { DocumentVector.new(document_vector_arguments) }

    context "when data input data is invalid" do

      # I prefer repeating some code instead of using shared examples. I simply hate them.

      let(:document_vector_arguments) { nil }

      context "when input data is empty" do

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

      context "when input data isn't a string" do

        let(:document_vector_arguments) { ["some_foo_param"] }

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

    end

    context "when input data is valid" do

      let(:document_vector_arguments) { noticia }

      let(:document_vector) { subject }

      it "sets the content" do
        expect(document_vector.content).to eq(noticia)
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
        expect(subject).to eq(1.fdiv(13))
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

        it "returns true" do
          expect(subject).to be(false)
        end

      end

    end

  end

end
