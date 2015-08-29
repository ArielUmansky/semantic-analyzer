require 'rails_helper'
require 'require_all'

require_all 'app/models/'

RSpec.describe Corpus do

  let(:noticia1_grupo1) {  "Boca venció a River por 5 a 0 en el clásico de verano"}
  let(:noticia2_grupo1) {  "Tras la goleada, los afiches de Boca gastando a las gallinas, empapelaron la ciudad"}

  describe "#initialize" do

    subject { Corpus.new(corpus_arguments) }

    context "when data input data is invalid" do

      # I prefer repeating some code instead of using shared examples. I simply hate them.

      let(:corpus_arguments) { nil }

      context "when input data is empty" do

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

      context "when input data isn't an array" do

        let(:corpus_arguments) { "some_foo_param" }

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

      context "when input data isn't an array of strings" do

        let(:corpus_arguments) { [1, 2, 3] }

        it "fails correctly" do
          expect { subject }.to raise_error(Analyzer::WRONG_INPUT_EXCEPTION)
        end

      end

    end

    context "when input data is valid" do

      let(:corpus_arguments) { [noticia1_grupo1, noticia2_grupo1] }

      let(:corpus) { subject }

      it "creates an array of documents" do
        expect(corpus.count).to eq(2)
      end

      it "the arrays of documents created contains the documents" do
        expect(corpus.documents).to eq(corpus_arguments)
      end

      it "calculates the global term array" do

      end

      it "calculates the vector space for each document" do

      end

    end

  end

end
