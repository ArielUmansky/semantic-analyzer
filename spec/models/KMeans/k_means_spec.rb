require 'rails_helper'
require 'require_all'

require_all 'app/models/KMeans'

RSpec.describe KMeans do

  #Set up de news of the fixture
  let(:noticia1_grupo1) {  "Boca venció a River por 5 a 0 en el clásico de verano"}
  let(:noticia2_grupo1) {  "Tras la goleada, los afiches de Boca gastando a las gallinas, empapelaron la ciudad"}
  let(:noticia3_grupo1) {  "Boca goleó a River en una jornada histórica ayer en Mar del Plata "}
  let(:noticia4_grupo1) {  "Repercusiones del superclásico de ayer"}

  let(:noticia1_grupo2) {  "Fuertes inundaciones en sectores de la Provincia de Buenos Aires a causa del temporal"}
  let(:noticia2_grupo2) {  "Scioli no hace declaraciones por las inundaciones en la Provincia"}
  let(:noticia3_grupo2) {  "Macri criticó a Scioli por no estar presente en el país durante las inundaciones"}
  let(:noticia4_grupo2) {  "Desde el Frente para la Victoria criticaron duramente a la oposición por la utilización política del temporal"}

  let(:noticia1_grupo3) {  "Argentina pierde la final de la Copa América frente a Chile por penales"}
  let(:noticia2_grupo3) {  "Ayer, Chile venció a la Argentina por penales y se coronó campeón de América por primera vez en su historia"}
  let(:noticia3_grupo3) {  "Fuertes críticas a Martino por la derrota de la selección" }

  let(:corpus) { Corpus.new([noticia1_grupo1, noticia1_grupo2, noticia1_grupo3, noticia2_grupo1,
                  noticia2_grupo2, noticia2_grupo3, noticia3_grupo1, noticia3_grupo2,
                  noticia3_grupo3, noticia4_grupo1, noticia4_grupo2]) }

  it "works" do
    pending
    kmeans = KMeans.new
    result_set = kmeans.execute(corpus)
    expect(result_set).to be (noticia1_grupo1)
  end

end
