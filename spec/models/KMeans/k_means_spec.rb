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

  let(:metadata) { nil }

  it "works" do
    pending
    kmeans = KMeans.new
    result_set = kmeans.pretty_result_set(kmeans.execute(corpus_arguments, metadata))
    expect(result_set).to eq()
  end

end
