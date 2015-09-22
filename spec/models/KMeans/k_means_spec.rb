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

  let(:noticia1_grupo4) { "Pablo Trapero ganó el premio al mejor director en el festival de Venecia por El Clan"}

  let(:noticia1_grupo5) { "Guerra en la farándula: Rial vs Canosa. La pelea de los mediáticos"}
  let(:noticia2_grupo5) { "Ayer en el programa de los culos del espectáculo, Rial y Canosa protagonizaron una fuerte disputa que terminó siendo reproducida por todos los programas de la tarde de la televisión argentina"}


  let(:corpus_arguments) {[{document: noticia1_grupo1}, {document: noticia2_grupo1}, {document: noticia3_grupo1},
                           {document: noticia1_grupo2}, {document: noticia2_grupo2}, {document: noticia1_grupo3},
                           {document: noticia2_grupo3}]}

  let(:politica) { "política" }
  let(:deportes) { "deportes" }
  let(:internacionales) { "internacionales" }
  let(:espectaculos) { "espectáculos" }

  let(:keywords_n1g1) { ["Alemania", "Austria", "guerra", "Siria", "inmigrantes"]}
  let(:keywords_n2g1) { ["Argentina", "guerra", "Siria", "Anibal Fernandez", "inmigrantes"]}
  let(:keywords_n3g1) { ["guerra", "Siria", "niño", "muerto", "fotografía", "Irán"]}

  let(:keywords_n1g2) { ["Argentina", "Bolivia", "amistoso", "Lavezzi", "Aguero", "Messi", "Correa"]}
  let(:keywords_n2g2) { ["Argentina", "Bolivia", "amistoso", "goleada"]}

  let(:keywords_n1g3) { ["Resultados", "PASO", "Scioli", "Cambiemos"]}
  let(:keywords_n2g3) { ["PASO", "presidenciales", "Macri"]}

  let(:keywords_n1g4) { ["Pablo Trapero", "Festival de Venecia", "El Clan"]}

  let(:keywords_n1g5) { ["Guerra", "Canosa", "Rial"]}
  let(:keywords_n2g5) { ["Rial", "Canosa", "pelea"]}

  let(:metadata) do
    {
        nmb_of_centroids: number_of_centroids
    }
  end

  let(:number_of_centroids) { 4 }

  let(:kmeans) { KMeans.new }

  let(:corpus) { Corpus.new(corpus_arguments) }

  describe "#execute" do

    subject { kmeans.execute(corpus_arguments, metadata) }

    it "works" do
      result_set = kmeans.pretty_result_set(subject)
      expect(result_set).to be_a(Array)
    end

    context "when there are categories" do

      let(:number_of_centroids) { 5 }

      let(:corpus_arguments) {[{document: noticia1_grupo1, category: internacionales}, {document: noticia2_grupo1, category: internacionales}, {document: noticia3_grupo1, category: internacionales},
                               {document: noticia1_grupo2, category: deportes}, {document: noticia2_grupo2, category: deportes}, {document: noticia1_grupo3, category: politica},
                               {document: noticia2_grupo3, category: politica},
                               {document: noticia1_grupo4, category: espectaculos},
                               {document: noticia1_grupo5, category: espectaculos}, {document: noticia2_grupo5, category: espectaculos}]}

      it "works" do
        result_set = kmeans.pretty_result_set(subject)
        expect(result_set).to be_a(Array)
      end

    end

    context "when there are keywords" do

      let(:number_of_centroids) { 4 }

      let(:corpus_arguments) {[{document: noticia1_grupo1, keywords: keywords_n1g1}, {document: noticia2_grupo1, keywords: keywords_n2g1}, {document: noticia3_grupo1, keywords: keywords_n3g1},
                               {document: noticia1_grupo2, keywords: keywords_n1g2}, {document: noticia2_grupo2, keywords: keywords_n2g2}, {document: noticia1_grupo3, keywords: keywords_n1g3},
                               {document: noticia2_grupo3, keywords: keywords_n2g3},
                               {document: noticia1_grupo4, keywords: keywords_n1g4},
                               {document: noticia1_grupo5, keywords: keywords_n1g5}, {document: noticia2_grupo5, keywords: keywords_n2g5}]}

      it "works" do
        result_set = kmeans.pretty_result_set(subject)
        expect(result_set).to be_a(Array)
      end

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

    context "when there is no categories" do

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

      context "when two documents have similar tf-idf but are from different categories" do

        let(:document) { corpus.document_vector_list[1] }

        let(:test_centroids) {
          [corpus.document_vector_list[0], corpus.document_vector_list[3], corpus.document_vector_list[6]]
        }

        it "returns the centroid of the most similar document which is an unsuccessful result " do
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

    context "when there are categories" do

      context "when two documents have similar tf-idf but are from different categories" do

        let(:corpus_arguments) {[{document: noticia1_grupo1, category: internacionales}, {document: noticia2_grupo1, category: internacionales}, {document: noticia3_grupo1, category: internacionales},
                                 {document: noticia1_grupo2, category: deportes}, {document: noticia2_grupo2, category: deportes}, {document: noticia1_grupo3, category: politica},
                                 {document: noticia2_grupo3, category: politica} ]}

        let(:document) { corpus.document_vector_list[1] }

        let(:test_centroids) {
          [corpus.document_vector_list[0], corpus.document_vector_list[3], corpus.document_vector_list[6]]
        }

        it "returns the centroid of the most similar document that belongs to the same category which is an expected result " do
          centroids = Array.new

          test_centroids.each do |document|
            centroid = Cluster.new
            centroid.add_document(document)
            centroids << centroid
          end

          expect(kmeans.find_closest_cluster_center(centroids, document)).to eq(0)

        end

      end

    end

  end

  describe "#initialize_centroids" do

    before(:each){
      kmeans.set_number_of_centroids(corpus, metadata)
    }

    subject { kmeans.initialize_centroids(corpus) }

    context "when there aren't categories" do

      it "the centroids are chosen randomly" do
        centroids = subject
        expect(centroids.count).to eq(number_of_centroids)
      end

    end

    context "when there are categories" do

      let(:corpus_arguments){ [{document: noticia1_grupo1, category: internacionales}, {document: noticia2_grupo1, category: internacionales}, {document: noticia3_grupo1, category: internacionales},
                              {document: noticia1_grupo2, category: deportes}, {document: noticia2_grupo2, category: deportes},
                              {document: noticia1_grupo3, category: politica}, {document: noticia2_grupo3, category:politica},
                              {document: noticia1_grupo4, category: espectaculos}]}

      before(:each){
        kmeans.instance_variable_set(:@set_of_categories, categories)
      }

      context "when there is the same amount of centroids than categories" do

        let(:categories) { [politica, deportes, internacionales, espectaculos]}

        it "generates an array whose size is equals to the number of centroids" do
          centroids = subject
          expect(centroids.count).to eq(number_of_centroids)
        end

        it "each centroid has a different category" do
          centroids = subject
          expect(Set.new(centroids.map { |centroid| centroid.category }).count).to eq(number_of_centroids)
        end

      end

      context "when there are more categories than centroids" do

        let(:categories) { [internacionales, deportes]}

        let(:corpus_arguments){ [{document: noticia1_grupo1, category: internacionales}, {document: noticia2_grupo1, category: internacionales}, {document: noticia3_grupo1, category: internacionales},
                                 {document: noticia1_grupo2, category: deportes}, {document: noticia2_grupo2, category: deportes}]}

        it "generates an array whose size is equals to the number of centroids" do
          centroids = subject
          expect(centroids.count).to eq(number_of_centroids)
        end

        it "each centroid has a different category" do
          centroids = subject
          expect(Set.new(centroids.map { |centroid| centroid.category }).count).to eq(categories.count)
        end

      end

      context "when there are less categories than centroids" do

        let(:number_of_centroids) { 3 }
        let(:categories) { [politica, deportes, internacionales, espectaculos]}

        it "generates an array whose size is equals to the number of centroids" do
          centroids = subject
          expect(centroids.count).to eq(number_of_centroids)
        end

        it "there will be a centroid for each category limited by the number of centroids" do
          centroids = subject
          expect(Set.new(centroids.map { |centroid| centroid.category }).count).to eq(number_of_centroids)
        end

      end

    end


  end

end
