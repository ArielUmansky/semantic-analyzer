require 'rails_helper'
require 'require_all'

require_all 'app/models/KMeans'
require_all 'app/helpers'

RSpec.describe KMeans do

  #Set up de news of the fixture

  let(:noticia1_grupo1) { "Alemania y Austria reciben inmigrantes Sirios de la guerra. Tras varios contactos diplomáticos entre los países europeos, los agentes gubernamentales de ambos países intentan facilitar la llegada de inmigrantes"}
  let(:noticia2_grupo1) { "Argentina abre las puertas a inmigrantes de la guerra en Siria. Anibal Fernandez dijo que este gobierno muestra un comportamiento solidario con todos los seres humanos que quieran habitar el suelo argentino"}
  let(:noticia3_grupo1) { "Fuerte conmoción mundial por las imágenes del niño fallecido en las costas de Irán intentando escapar de los conflictos que tienen lugar en Siria"}

  let(:noticia1_grupo2) { "Argentina destrozó a Bolivia ayer en Houston por 7 a 0. Con dos goles de Lavezzi, Aguero y Messi y uno de Correa, Argentina derrotó en un amistoso a Bolivia, que llegó a últio momento al encuentro y estrenaba entrenador"}
  let(:noticia2_grupo2) { "El equipo de Martino venció por 7 a 0 a Bolivia en un amistoso en Estados Unidos. Messi entró en el segundo tiempo y 25 minutos le alcanzaron para marcar dos goles"}

  let(:noticia1_grupo3) { "Scioli venció en las PASO nacionales con un 38% de los votos. Cambiemos, con el segundo lugar, en conjunto sumó un 31%. La tercera fuerza fue el Frente Renovador, con los aportes de Massa y De La Sota"}
  let(:noticia2_grupo3) { "El Frente para la Victoria alcanzó el primer lugar en las PASO nacionales con un 38% de los votos. Macri, con un 24% dentro de la interna de Cambiemos, es el segundo candidato en la carrera presidencial hacia Octubre, Massa ocupó el tercer lugar, con un 11% de los votos"}


  let(:corpus_arguments) {[noticia1_grupo1, noticia2_grupo1, noticia3_grupo1, noticia1_grupo2, noticia2_grupo2, noticia1_grupo3, noticia2_grupo3]}

  let(:metadata) do
    {
        nmb_of_centroids: 4
    }
  end

  let(:kmeans) { KMeans.new }

  describe "#execute" do

    subject { kmeans.execute(corpus_arguments, metadata) }

    it "works" do
      #pending
      result_set = kmeans.pretty_result_set(subject)
      expect(result_set).to be_a(Array)
    end

  end

  describe "#cosine_similarity" do

    let(:vector_space_A) { [0.2, 0.1, 10, 10, 0, 0.5, 10, 0, 1, 0.2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] }
    let(:vector_space_B) { [0, 1, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }
    let(:distant_vector_space) { [10, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }

    it "returns greater results between vectors that are similar" do
      high_similarity = kmeans.cosine_similarity(vector_space_A, vector_space_B)
      low_similarity1 = kmeans.cosine_similarity(vector_space_A, distant_vector_space)
      low_similarity2 = kmeans.cosine_similarity(vector_space_B, distant_vector_space)

      expect(high_similarity > low_similarity1).to be true
      expect(high_similarity > low_similarity2).to be true
    end
  end

  describe "#find_closest_cluster_center" do

    let(:corpus) { Corpus.new(corpus_arguments) }

    let(:document) { corpus.document_vector_list[4] }

    let(:test_centroids) {
      [corpus.document_vector_list[1], corpus.document_vector_list[3], corpus.document_vector_list[6]]
    }

    it "returns the index of the closest centroid" do
      centroids = Array.new

      test_centroids.each do |document|
        centroid = Cluster.new
        centroid.add_document(document)
        centroids << centroid
      end

      expect(kmeans.find_closest_cluster_center(centroids, document)).to eq(1)

    end

  end

end
