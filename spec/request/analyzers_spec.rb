require "rails_helper"

RSpec.describe "Analyzer", :type => :request do

  describe "POST /analyzer" do

    subject { post("/analyzer", req_params, nil) }

    context "when there are problems with the request" do

      context "when the body is empty" do
        let(:req_params) { nil }

        it "returns bad request" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

      end

      context "when the there is a body but there is no corpus data" do
        let(:req_params) do
          {
              body: { foo: "foo" }
          }
        end

        it "returns bad request" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

      end


      context "when the there is a body but the algorithm configured is not supported" do
        let(:req_params) do
          {
              body: { corpus: ["foo"],
                      algorithm: "foo" }
          }
        end

        it "returns bad request" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

      end

      context "when kmeans is the algorithm selected" do

        context "when the required metadata is missing" do
          let(:req_params) do
            {
                body: { corpus: ["foo"],
                        algorithm: Analyzer::KMEANS }
            }
          end

          it "returns bad request" do
            subject
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

      end

    end

    context "when request is correct" do
      let(:req_params) do
        {
            body: {
                corpus: corpus,
                algorithm: algorithm,
                metadata: {
                  nmb_of_centroids: 2
                }
            }
        }
      end

      let(:corpus) { [ { document: "foo", category: "politics", keywords: ["foo"] }, { document:"bar", category: "sports", keywords: ["bar"] } ] }
      let(:algorithm) {Analyzer::KMEANS }

      it "returns http status ok" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "returns a result_set" do
        subject
        expect(JSON.parse(response.body)["result_set"]).to be_a(Array)
      end

      it "returns the algorithm used" do
        subject
        expect(JSON.parse(response.body)["algorithm"]).to eq(Analyzer::KMEANS)
      end

      context "when algorithm is not present" do
        let(:algorithm) { nil }

        it "returns http status ok" do
          subject
          expect(response).to have_http_status(:ok)
        end

        it "assumes kmeans" do
          subject
          expect(JSON.parse(response.body)["algorithm"]).to eq(Analyzer::KMEANS)
        end

      end

    end

    context "real tests" do

      let(:corpus) do
        [
            {
                :document=>"Nelson Castro: Señora Presidenta, usted no tiene compasión Nelson Castro opinó acerca de lo que Cristina Kirchner declaró en su discurso, en el día en el que murió un chico índigena de la comunidad qom por desnutrición. Señora Presidenta, usted no tiene compasión. Es esto lo que representa la disparatada frase que dijo, lanzó el periodista. Cristina había asegurado que no quería parecerse a países que dejan morir chicos en las playas, aunque no emitió palabra sobre el adolescente chaqueño que murió. Es esta idea que usted tiene acerca de que nuestro país es un paraíso el problema. Tenemos la obligación de marcar las cosas que usted no ve, que son muchas, comentó Nelson Castro. Y remarcó: ¿Y sabe qué, Presidenta? Hay una muerte de un chico por falta de comida en la Argentina. Increíble: por falta de comida en la Argentina. Finalmente, el periodista agregó: La muerte de un chico debería a usted pesarle como reconocimiento de la realidad. Y para que por lo menos intente hacer algo en lo que le quede de mandato, para que no se repita otra muerte.",
                :keywords=>["Chaco", " Refugiados"],
                :category=>"politics"
            },
            {
                :document=>"Para Cano, el daño en los videos de vigilancia de las urnas fue absolutamente un sabotaje El candidato a gobernador de Tucumán por Acuerdo para el Bicentenario, José Cano, sostuvo hoy que absolutamente fue un sabotaje el daño a los videos de las cámaras que debían vigilar el ingreso de las urnas al edificio de la Junta Electoral, tras los comicios del 23 de agosto. Para Cano esto confirma cada una de las presentaciones que la oposición tucumana hizo respecto a las irregularidades cometidas durante la elección provincial. Al ser consultado en sobre si cree que hubo sabotaje respecto a las filmaciones, Cano respondió: Absolutamente, esto forma parte de una coartada. En las últimas horas se conoció que los videos de las cámaras que controlaban el ingreso y egreso de las urnas en el edificio de la Junta Electoral, se dañaron a raíz de problemas de tensión y cortes de energía. La Junta Electoral de Tucumán admitió ayer que desaparecieron las filmaciones de las cámaras de seguridad instaladas en el local donde están guardadas las urnas desde la noche de la votación. El organismo informó que los videos se perdieron a raíz de un corte de energía que provocó daños irreparables en los equipos.",
                :keywords=>["Tucuman", "Fraude", "Elecciones"],
                :category=>"politics"
            },
            {
                :document=>"La muerte del chico qom: ¿Qué tiene que ver el Gobierno, entonces también tiene que ver con el hambre en África? En principio, ¿qué tiene que ver el gobierno nacional? ¿Entonces también tenemos que ver nosotros con el hambre y la miseria en África?. Con esa frase, el jefe de Gabinete, Aníbal Fernández, se desligó de la muerte del chico qom en el Chaco. Estamos hablando de un chico que tiene un problema congénito con un deterioro permanente que le produce la imposibilidad de asimilar alimentos, se justificó. Ayer la Presidenta habló de los chicos que mueren en las playas, por los refugiados, pero no dijo ni una palabra de esta nueva muerte qom. El jefe de Gabinete criticó que se realice un uso político de la muerte del chico qom por desnutrición en el Chaco e insistió que se trató de un “caso congénito”.",
                :keywords=>["Quom", "Anibal Fernandez", "Chaco", "Refugiados"],
                :category=>"politics"
            },
            {
                :document=>"Ídolo y semifinalista: el gran gesto de Federer con un nene en el US Open Luego de ganarle al francés Gasquet y clasificarse a la semifinal del US Open, Roger Federer volvió a demostrar por qué es el tenista más querido y uno de los deportistas más admirados del mundo. Mientras firmaba autógrafos tuvo un gesto con un nene que estaba en primera fila de la platea, y que estaba siendo aplastado por los demás fans que también querían su firma. El suizo les pidió a los hombres de seguridad que le acercaran al niño y le firmó la gorra y una pelota de tenis de las grandes. Federer jugará mañana la semifinal del Abierto de Estados Unidos ante su compatriota Stanislas Wawrinka.",
                :keywords=>["Federer", "Tenis"],
                :category=>"sports"
            },
            {
                :document=>"Ayer terminó todo: el duro testimonio del padre del adolescente qom que murió de desnutrición Con pocas palabras, el padre de Oscar Sánchez, el adolescente qom de 14 años que murió el miércoles en la provincia de Chaco, resumió su inmenso dolor: Ayer terminó todo. Ya no hablo más. Héctor Sánchez dialogó con La Nación, tras la pérdida de su hijo, que pesaba 10 kilos. Tendrían que haber venido a preguntarme hace dos años, se lamentó el hombre. La muerte del joven se produjo el miércoles en el hospital pediátrico de Resistencia, al que había sido trasladado el jueves anterior desde otro centro de salud de Castelli. Según las estadísticas que lleva el centro de estudios Nelson Mandela, es la sexta muerte de menores de edad indígenas en la zona de El Impenetrable en lo que va del año. Esa organización no gubernamental afirmó que se trata de un nuevo caso de muerte injusta y altamente evitable, que deriva del deshumanizado y desorganizado funcionamiento del sistema socio-sanitario público de Chaco. Por su parte, el gobernador provincial Jorge Capitanich afirmó que el pueblo de Chaco sabe muy bien lo que nos falta. Sentimos dolor cuando alguien se muere por una serie de factores o falencias desde el punto de vista cultural, en un acto político en esa provincia. Sin nombrar al chico que murió, haciendo siempre referencia a la campaña política y criticando a sectores opositores, Capitanich remarcó que le duele cuando muere un niño por una causa evitable y que cree que hay que hacer más.",
                :keywords=>["Qom", "Refugiados"],
                :category=>"politics"
            },
            {
                :document=>"El crimen de María Soledad: 25 años de un caso que cambió el país Recordá a la estudiante secundaria María Soledad Morales a 25 años de su crimen en Catamarca con este recorrido visual por el caso que conmovió a la Argentina. El brutal asesinato de María Soledad, que arrancó con las llamadas Marchas del Silencio y también provocó la renuncia del gobernador provincial Ramón Saadi, se descubrió el 10 de septiembre de 1990, cuando trabajadores de Vialidad encontraron su cuerpo mutilado y semiescondido en el Parque Daza. Los informes médicos aseguraron que la joven había sido violada y asesinada 48 horas antes del hallazgo de su cuerpo, entre el 7 y el 8 de septiembre. A partir del hallazgo del cuerpo, siete jueces investigaron el caso y entre sospechas de encubrimiento y de protección política, la causa fue elevada a juicio oral. En 1996, el tribunal dio inicio al debate que tuvo a Guillermo Luque -hijo del diputado nacional por el peronismo, Ángel Luque- y a Luis Raúl Tula, acusados por el crimen con diferentes grados de participación. Sin embargo, este juicio debió suspenderse ante escenas de fraude que fueron captadas por las cámaras de televisión que en ese momento transmitían en vivo y en directo las jornadas del debate. Otro tribunal decidió retomar el debate al año siguiente y el 27 de febrero de 1998 Luque fue condenado a 21 años de prisión y Tula a 9 años por violación seguida de muerte agravada por el uso de estupefacientes. Tula, que ahora tiene 54 años, cumplió la totalidad de la condena, mientras que Luque, actualmente de 49 años, pasó en prisión 14 años y al cumplir dos tercios de la pena obtuvo la libertad condicional por buen comportamiento durante la detención.",
                :keywords=>["Maria Soledad", " Ni una menos"],
                :category=>"police"
            },
            {
                :document=>"Modelo, morocha y de ojos claros: ésta sería la nueva novia de Chano A horas de que Juanita Viale blanqueara a su nuevo novio millonario, su ex, Chano, el cantante de Tan Biónica hizo lo mismo. A su candidata no le sobran los verdes, pero los de ella no se consiguen en ningún lado. La afortunada se llama Florencia Almada, es modelo de una conocida agencia, tiene 21 años y vive en Rosario. Su plus más destacado es la mirada...a esos verdes nos referíamos. Al músico de 33 años no le importan la distancia, ni la diferencia de edad (¡ni la carita de teen de ella!). Hace unos días, viajó a Rosario para ver a Florencia y ambos fueron vistos en un centro comercial de la capital, a los mimos, como novios. Según revelaron en AM, la joven es el principal sostén emocional del cantante después del polémico accidente que protagonizó en Belgrano y la familia de él está chocha con la nueva relación.",
                :keywords=>["Chano"],
                :category=>"entertainment"
            },
            {
                :document=>"Brasil: reunión de gabinete de urgencia y real a 3,90 tras la pérdida del grado de inversión En el que es tal vez el peor día desde que Dilma Rousseff asumió como presidenta tras la pérdida de la calificación confiable de grado de inversión a la deuda brasileña dictado por la agencia S&P, todo el gabinete ministerial fue convocado hoy a una reunión de emergencia mientras el real llegó a los 3,90 por dólar. La bolsa de San Pablo pierde un 1,5%. El banco central brasileño desde temprano anunció una intervención de 1.500 millones de dólares para frenar la devaluación. En paralelo, Rousseff convocó a todo su gabinete para analizar el nuevo escenario económico y político. La pérdida del grado de inversión le implicará a Brasil más desconfianza de los inversores, pérdida de inversiones y pagar tasas de interés más cara a la hora de tomar deuda, tanto para el Estado como para las empresas. Brasil está ahora focalizado el lograr superávit fiscal en 2016 con una serie de medidas antipáticas de ajuste que empujaron a la economía a la recesión, que se mantendrá hasta 2016. Rousseff, a su vez, pasa por su peor momento político. El grado de aceptación de su gestión apenas llega al 7 por ciento de la población. A la salida de la reunión de gabinete, la presidenta afirmó que el gobierno continúa trabajando para mejorar la ejecución fiscal y tornarla sustentable, en una entrevista con el diario Valor. “Es fundamental la recuperación del crecimiento. Entre 1994 y 2015 solo en siete años, a partir de 2008 la nota fue superior a BB+. Por eso, esa (nueva) clasificación no significa que Brasil esté en una situación en la que no pueda cumplir sus obligaciones. Al contrario, está pagando todos sus contratos y tenemos una clara estrategia económica. Vamos a continuar en ese camino y vamos a retomar el crecimiento de este país”, analizó la presidenta. Dilma anunció que en las próximas semanas enviará al Congreso propuestas para aumentar los impuestos y recortar los gastos, como remedio para paliar el déficit fiscal previsto para el próximo año en el proyecto de presupuesto. Los problemas fiscales fueron uno de los argumentos que utilizó S&P para bajar la calificación de la deuda a niveles especulativos.",
                :keywords=>["Brasil", "Dilma Rouseff"],
                :category=>"world"
            },
            {
                :document=>"Conocé el line up de Creamfields 2015 Ya se van conociendo los nombres de los artistas que estarán en el gran escenario de Creamfields BA que cumple 15 años. El sábado 14 de noviembre, en Costanera Sur se podrá disfrutar de referentes de la música electrónica mundial y artistas locales. Line Up: Dimitri Vegas & Like Mike / Nervo / Richie Hawtin / Luciano / Sven Vath / Solomun / Maceo Plex / Hernan Cattaneo / The Martinez Brothers / Paul Oakenfold / Art Department / Hot Since 82 / Pan-Pot / Popof / Matador/ Krewella / Marcel Dettman / Patrick Topping / Ilario Alicante / Guti / Barem / Bassjackers / Mano Le Tough / Franco Cinelli / Christian Burkhardt, entre otros.",
                :keywords=>["Creamfields 2015", " Creamfields BA"],
                :category=>"entertainment"
            },
            {
                :document=>"Zannini marcó la cancha: Comparemos a Scioli con Macri, Massa, Stolbizer o del Caño, no con la presidenta, ya que nadie va a tomar su lugar El secretario de Legal y Técnica y candidato a la Vicepresidencia por el kirchnerismo, Carlos Zannini, advirtió hoy que nadie va a tomar el lugar de la presidenta Cristina Kirchner cuando termine su mandato, y pidió comparar a quien encabeza la fórmula oficialista, Daniel Scioli, con los otros postulantes de la oposición, pero no con la mandataria. El aspirante a vicepresidente aseveró: Hacemos una gran injusticia con Daniel Scioli al compararlo con Cristina, ninguno es comparable con Cristina y, tras resaltar que la jefa de Estado es la centralidad en la política argentina de hoy, dijo que ella va a seguir siendo Cristina e inolvidable. Zannini formuló estos conceptos por radio Nacional un día después de que en un acto público, que compartió con el ex mandatario brasileño Inacio Da Silva, Cristina Kirchner señalara que cuando uno ha ejercido la Presidencia como lo ha hecho Lula nunca deja de ser presidente. Cuando se le preguntó qué lugar tendrá el actual gobernador bonaerense de acceder al Ejecutivo nacional, el segundo de la fórmula oficialista contestó: Va a tener que hacerse cargo del timón; cualquiera, Scioli, Macri...Porque esta es una cuestión que desde el kirchnerismo planteamos: ¿Quién va a tomar el lugar de Cristina? Nadie. En una idea que enmarcó en el realismo mágico, Zannini le reprochó a la oposición creer que un nuevo gobierno va a evaporar la figura de la actual mandataria en el imaginario colectivo de los argentinos. Los opositores creen que el 10 de diciembre hay un fenómeno mágico que hace evaporar a Cristina, al kichnerismo, a la Cámpora, se lamentó el secretario de Estado y pronosticó que eso no será así. En tal sentido, expresó que nosotros hemos estado en la historia de argentina 12 años y hemos hechos cosas muy importantes que van a quedar en el corazón del pueblo. Al mencionar la ampliación de derechos y la política en derechos humanos, se preguntó: ¿Qué van a hacer para que se olviden de Cristina? ¿Van a derogar el matrimonio igualitario? ¿Van volver al Fondo Monetario para pedir un 'stand by'? Nosotros dejamos de estar en el Fondo porque le pagamos. Al insistir en rechazar ese presunto pensamiento mágico de que vamos a desaparecer, Zannini enfatizó que la Presidenta se va con un nivel de imagen espectacular después de 12 años de gestión kirchnerista. En esa línea, evaluó que Cristina Kirchner tuvo lo que tenía que tener cuando estuvo en ese cargo, entonces va a ser inolvidable.",
                :keywords=>["Zannini", " Elecciones"],
                :category=>"politics"
            },
            {
                :document=>"Se cayó un techo en el hospital de durlock de Resistencia donde murió el adolescente qom Oscar Sánchez Otra conmoción en Chaco. Se cayó un techo en el hospital de durlock de Resistencia, el mismo establecimiento donde murió Oscar Sánchez, en adolescente qom que perdió la vida por un severo cuadro de desnutrición, tuberculosis y meningitis. El derrumbe en la planta baja, que obligó a evacuar a algunos sectores, se provocó por la rotura de cañerías que colapsaron la estructura. El video llegó a TN y la Gente, el portal de periodismo ciudadano de TN.com.ar. Según el usuario, ocurrió a las 10 de la mañana en la zona de kinesiología donde se atienden nenes discapacitados entre los 0 y 16 años. Por su parte, la directora del Hospital Pediátrico, Alicia Michelini, tal como consigna el portal DataChaco, detalló que personal de mantenimiento, médicos y enfermos ayudan a sacar el agua y a los pacientes que son atendidos en los consultorios. Además, está suspendido el servicio de energía eléctrica. Michelini dijo además que las tuberías proveían de agua al primer piso de internación. Toda la semana trabajan para mejorar esta situación. El especialista que hizo la estructura tenía problemas con la distribución del agua fría y caliente, y se vienen realizando revisiones constantes, afirmó. El Hospital Pediátrico de Resistencia Avelino Castelán llevó años de construcción, pero está hecho de durlock. Así las embarazadas están expuestas a los Rayos X. Una placa reveló que la radiación traspasaba las paredes de durlock de la sala de rayos. Fue inaugurado este año por Cristina Kirchner, en un predio de cuatro manzanas, donde ya funciona el Hospital “J.C. Perrando” de alta complejidad. Aunque fue construido con durlock demandó $220.000.000, de los cuales $180 millones fueron invertidos en la obra por la provincia de Chaco y $40 millones por el Estado Nacional para equipamiento. Play CORTE DE CINTA. Fue el 7 de mayo último.",
                :keywords=>["Chaco", "Qom"],
                :category=>"politics"
            },
            {
                :document=>"Por los refugiados, Barcelona y el Atlético Madrid usarán una camiseta especial Atlético Madrid y Barcelona se unirán en apoyo a los refugiados. Ambos equipos, que se enfrentan el sábado en el Vicente Calderón, vestirán una camiseta en favor de los refugiados.",
                :keywords=>["Refugiados"],
                :category=>"politics"
            },
            {
                :document=>"Niembro: la legislatura porteña aprobó un pedido de informes En una sesión sin discursos ni debate, el Poder Legislativo de la Ciudad de Buenos Aires aprobó un pedido para que el gobierno de Mauricio Macri informe sobre las contrataciones con la empresa vinculada a Fernando Niembro. El proyecto fue presentado por la presidenta del bloque del Frente para la Victoria, Gabriela Alegre y busca conocer los productos contemplados en los contratos, las áreas, la modalidad y el monto de los servicios. Se trata de información sobre de un número importante de contrataciones, no menos de 160, que se habrían llevado adelante de modo irregular, confirmó la legisladora. Además, los diputados presentarán un pedido de interpelación para el Jefe de Gobierno Porteño, Mauricio Macri, el Jefe de Gabinete, Horacio Rodríguez Larreta y la Vicejefa de Gobierno y candidata a Gobernadora de Buenos Aires por el PRO, María Eugenia Vidal. Anoche, Niembro y Alegre estuvieron cara a cara en el programa A dos voces y debatieron sobre la denuncia por supuestas irregularidades en contratos del Gobierno de la Ciudad con la productora La Usina, de la que el candidato del PRO fue parte.",
                :keywords=>["Niembro", "Macri"],
                :category=>"politics"
            },
            {
                :document=>"Tras la caída del techo, así está el hospital de durlock en Chaco Estas son las imágenes del techo caído en el hospital de durlock de Resistencia. El derrumbe de mampostería, ocasionado por un caño roto, cayó en la planta baja del establecimiento, precisamente en el sector kinesiología donde se atienden nenes discapacitados entre los 0 y 16 años. Estos videos llegaron a TN y la Gente, el portal de periodismo ciudadano de TN.com.ar. Minutos después del derrumbe, se evacuó el área perjudicada ya que el agua inundó los pisos. Está suspendido, además, el servicio de energía eléctrica. Play Play Play TN Y LA GENTE PERIODISMO CIUDADANO. Mirá el video que llegó a TN y la Gente.",
                :keywords=>["Chaco", " Hospital"],
                :category=>"politics"
            },
            {
                :document=>"Piqué contra los hinchas del Real Madrid Gerard Piqué debe estar pasando uno de los momentos mas duros en su carrera como profesional. Silbado por los hinchas en los partidos de local que jugó la selección española, el defensor del Barcelona dio una conferencia de prensa que que sorprendió a más de uno. Lejos de calmar las aguas criticó duramente a los hinchas y en especial a los del Madrid. Mirá el video y la opinión de los hinchas.",
                :keywords=>["Piqué", " Barcelona"],
                :category=>"entertainment"
            },
            {
                :document=>"ExpoInternetLA, una mirada en primera persona a la Internet de las cosas La impresión 3D, uno de los temas de la muestra. Foto: LA NACION Ayer abrió sus puertas, en el predio de La Rural en Palermo, la muestra ExpoInternetLA, feria que extenderá su estadía hasta el próximo sábado, con una oferta que busca agradar a los amantes de la tecnología, Internet y los videojuegos. Luego de la acreditación correspondiente (las entradas tienen un precio que oscila entre 200 y 2000 pesos, dependiendo de la cantidad de días del pase elegido y las conferencias a las que se asistirá), comenzamos nuestro andar por los diferentes stands en donde algunas firmas daban los últimos retoques para recibir a los visitantes. Entre los diferentes juegos y experiencias, los concurrentes hacían cola desde el minuto uno para probar diferentes lentes de realidad virtual como los Oculus Rift, los Samsung Gear VR y hasta los económicos Cardboards de Google, fabricados en cartón. Lejos de los juegos en realidad virtual y los tradicionales paseos, empresas como Solutionario y Psytech ofrecen contenidos propios y adaptados para dicha tecnología, explotando características como la posibilidad de realizar tours virtuales, visitar hoteles y viviendas para compras o alquilar, hasta el abordaje de diferentes fobias mediante tratamientos virtuales. Los videojuegos, un atractivo siempre presente. Foto: LA NACION En el centro de la muestra se erige una jaula con drones de diferentes marcas y modelos en vuelo constante, circundando a su piloto. Más allá se distribuyen algunas empresas nacionales dedicadas a la fabricación de impresoras 3D, como FAR e-innovation o Replikat, que ya ofrece algunos de sus modelos en cadenas de ventas minoristas. Los videojuegos también tienen su espacio. Se puede jugar al GTA V en pantalla gigante mientras que el popular Preguntados puede ser disfrutado en un muro de grandes dimensiones, y hoy jueves por la noche prepara la presentación de su segunda versión. Otras actividades permiten controlar diminutos autos desde una tableta o ejercitar la mente utilizando una aplicación con el sensor de movimiento Kinect de Microsoft. La Internet de las cosas (en este caso, un lavarropas) también dijo presente en la feria. Foto: LA NACION Un pasillo lleva a la casa del futuro, mostrando diferentes tecnologías y productos conectados que pueden ser controlados desde una aplicación instalada en un celular o una tableta. Dos de las más concurridas eran Solidmation y Drean; empresas argentinas con la mirada puesta en el futuro conectado. Solidmation tiene en exposición un sistema de luces, parlantes y diferentes electrodomésticos que se ponen en funcionamiento de manera remota desde un celular, mientras que Drean mostró un lavarropas conectado a Internet que será lanzado al mercado de consumo en los próximos meses. Más allá de las experiencias que pueden ser disfrutadas por los concurrentes, la feria es también un buen lugar donde informarse y asesorarse. Algunos stands alojaban diferentes casas de estudios como la Universidad Abierta Interamericana e Image Campus, en donde las personas buscaban planes de estudios y carreras afines al desarrollo de videojuegos. Autitos a control remoto, pero manejados por una tableta. Foto: LA NACION Además de ofrecer diversas experiencias y un vistazo en primera persona al futuro tecnológico, Expo InternetLA incluye una agenda de conferencias que incluyen la impresión 3D (Andrei Vazhnov), la Internet de las cosas (Jorge Crom), el desarrollo web (Daniel Rabinovich), el impacto en la tecnología en la vida cotidiana (Santiago Bilinkis), la creatividad e innovación (Estanislao Bachrach), el arte y tecnología (María Luján Oulton), las redes sociales y la literatura (Ramiro Fernández) y el cierre con la presencia del cofundador de Apple, Steve Wozniak, mañana a las 7 de la tarde..",
                :keywords=>["ExpoInternetLA", " tecnologia"],
                :category=>"culture"
            },
            {
                :document=>"Cristina Kirchner recibió a Inácio Lula da Silva en la Casa Rosada La presidenta, Cristina Kirchner, compartió hoy un almuerzo con el ex mandatario de Brasil Luis Inácio Lula da Silva en Casa de Gobierno, como parte de las actividades que el ex presidente del país vecino viene manteniendo el país. La Presidenta recibió a las 13.25 a Lula en su despacho de la Casa Rosada, según consignaron fuentes oficiales. Tras una breve reunión, la jefa de Estado invitó a su visitante a compartir en el comedor presidencial un almuerzo privado durante el cual pasaron revista de la situación de la región. Además, participó el embajador del país vecino, Everton Vieira Vargas. El encuentro entre ambos se dio luego del acto que ayer compartieron junto al candidato presidencial del Frente para la Victoria, Daniel Scioli, en ocasión de la inauguración de una Unidad de Pronta Atención (UPA) en la localidad bonaerense de José C. Paz. Lula Da Silva se encuentra en el país para participar durante esta semana de distintas actividades de apoyo a Scioli de cara a las elecciones presidenciales de octubre..",
                :keywords=>["Cristina Kirchner y Lula da Silva"],
                :category=>"politics"
            },
            {
                :document=>"Fernando Farré pidió prisión domiciliaria y tobillera electrónica La defensa del viudo Fernando Farré, detenido por el femicidio de su esposa, Claudia Schaefer, en el country Martindale de Pilar, solicitó hoy para el acusado una prisión domiciliaria con tobillera electrónica, mientras que la fiscal y la querella pidieron que se le dicte la prisión preventiva. Adrían Tenca, abogado de Farré, presentó el pedido para que el acusado pueda permanecer en su domicilio; mientras que la fiscal del caso Carolina Carballido anteriormente había dictado la prisión preventiva por temor a que el imputado se diera la fuga. Fuentes judiciales informaron a Télam que ése fue el pedido de las partes en la audiencia oral que se realizó este mediodía ante el juez de Garantías 6 de Pilar, Nicolás Ceballos, quien mañana definirá la situación procesal del imputado. Agencia Télam.",
                :keywords=>["Farre"],
                :category=>"police"
            },
            {
                :document=>"Con el voto de Pro, la Legislatura porteña aprobó el pedido de informes al Ejecutivo sobre la empresa de Fernando Niembro La Legislatura de la Ciudad de Buenos Aires aprobó el pedido de informes al Poder Ejecutivo sobre las contrataciones del gobierno local con La Usina Producciones, vinculada al candidato a diputado nacional por el Pro, Fernando Niembro. El Pro votó a favor de esa medida, pero se negó a que se produzca un debate, por lo que el expediente deberá ser debatido en el ámbito de una comisión parlamentaria. Como respuesta, el bloque del kirchnerismo en la Legislatura porteña informó que pedirá interpelar al jefe de gobierno, Mauricio Macri y a la vicejefa, María Eugenia Vidal, ambos candidatos a presidente y a gobernadora bonaerense, respectivamente. Así lo informó la legisladora de Nuevo Encuentro, Gabriela Cerruti: Vamos a presentar un pedido de interpelación a Macri y Vidal para que vengan a la Legislatura. Sabemos que [Niembro] cobró. Ahora queremos saber quién pagó y de esa forma irregular, dijo en diálogo con la señal TN. Queremos saber sobre estas contrataciones directas que se efectúan sin ser presentados en el Boletín Oficial. Hay una cantidad de cuestiones que van saliendo de este tema. Vidal y Macri tienen que dar explicaciones. Lo que destapa este medio [La Usina Producciones], es que ha habido un mecanismo de sacar plata del Estado de Buenos Aires, ya sea para beneficio personal o de medios, con contrataciones directas sin que nadie brinde explicaciones, enfatizó Cerruti. Niembro dijo ayer que las sospechas no están fundamentadas en la realidad: Estoy enredado en una operación política, le dijo Niembro a LA NACION.Esto es una persecución política que llegó a la más alta esfera. Y qué casualidad que la Presidenta use la misma palabra que Carlos Zannini, ¿no?, concluyó. Más temprano, Macri respaldó a Niembro y atribuyó las acusaciones a una campaña negativa por las elecciones, en las que el jefe de gobierno compite como candidato por la Presidencia. Es todo legal, transparente, no hay nada extraño, por eso estamos muy tranquilos. La Ciudad compró servicios de calidad y a precios competitivos, sostuvo Macri en Radio Mitre, en referencia a las contrataciones entre la productora La Usina, de la que Niembro era socio, y el gobierno porteño. El candidato opositor sostuvo que se quiere deformar la realidad, denunció que la Casa Rosada quiere embarrar, ensuciar y alertó que van a inventar cosas peores porque hacen este tipo de cosas cuando llegan las campañas. En el mismo sentido, Carmen Polledo, jefa de bloque del PRO en la Legislatura, aseguró: No tenemos nada que esconder y calificó la denuncia contra Niembro como una maniobra donde lo único que se quiere es confundir a la ciudadanía..",
                :keywords=>["Niembro", " Pro"],
                :category=>"politics"
            },
            {
                :document=>"La alcaldesa de Madrid quiere que se cedan viviendas vacías para recibir refugiados MADRID.- Manuela Carmena, la alcaldesa de la capital de España, promueve que miles de familias madrileñas cedan al Ayuntamiento los departamentos vacíos que tengan para acoger en ellos a refugiados provenientes de Medio Oriente y África, haciéndose cargo el Estado del cuidado y del pago de gastos de expensas y servicios, además de comprometerse a devolverlos cuando el ciudadano los necesite. Sería aplicar el modelo de vivienda social que el Ayuntamiento planteó a los bancos trasladado ahora a familias dispuestas a dejar viviendas que tengan vacías para que el Ayuntamiento haga un uso social de ellas, explicó la alcaldesa. El Ayuntamiento está diseñando un plan específico en relación al drama de los refugiados. Se les facilitará asesoramiento jurídico, el acceso a viviendas, educación para los niños que han de ser escolarizados, ingresos económicos y cuestiones relativas a la salud, entre otras necesidades, planteó Carmena. Todo esto queremos liderarlo desde el Ayuntamiento pero recogiendo todas las solicitudes de apoyo de la ciudadanía que nos está llegando, añadió la primera edil. El Ayuntamiento ya está recogiendo nombres de madrileños que quieren actuar como 'familia-guía' para los refugiados, para ayudarles a resolver los problemas que se encuentren a su llegada a Madrid..",
                :keywords=>["Refugiados", " España"],
                :category=>"world"
            },
            {
                :document=>"La empresa de Niembro estaba inscripta para brindar servicios de astrología y espiritismo La información surge del sistema Nosis, según el cual se puede corroborar que la empresa La Usina Producciones S.R.L con la cual Fernando Niembro le facturó más de 20 millones de pesos al gobierno de Mauricio Macri se inscribió en AFIP en una categoría distinta a la que le correspondía.Nota Relacionada: Macri busca despegarse de Niembro y dice que no conocía a La Usina Según puede comprobar en el sistema de información Comercial y Crediticia de Empresas (Nosis) la empresa propiedad de los candidatos a diputados nacionales por la provincia de Buenos Aires por Cambiemos, Fernando Niembro y Alberto Atilio Meza, fue inscripta en la AFIP bajo la categoría Servicios Personales en lugar de la que le correspondería de Servicios de Publicidad o bien de Estudio de mercado, realización de encuestas de opinión pública. la usina producciones.jpgLa categoría en la cual fue inscripta en AFIP la empresa con la cual Niembro y su socio facturaron al gobierno de Macri contratos por más de 20 millones de pesos en tres años incluye actividades como astrología y espiritismo, las realizadas con fines sociales como agencias matrimoniales, de investigaciones genealógicas, de contratación de acompañantes, la actividad de lustra botas, acomodadores de autos, etc. La irregularidad en la inscripción pone al descubierto el apuro con el cual Niembro y su socio inscribieron la empresa con el objetivo de conseguir rápidamente una figura legal en la AFIP con la cual poder comenzar a facturar. la usina producciones.jpg",
                :keywords=>["Niembro"],
                :category=>"politics"
            },
            {
                :document=>"Fernando Farré pidió la prisión domiciliaria con tobillera electrónica Fuentes judiciales informaron que ese fue el pedido de las partes en la audiencia oral que se realizó este mediodía ante el juez de Garantías 6 de Pilar, Nicolás Ceballos, quien mañana definirá la situación procesal del imputado.",
                :keywords=>["Farre", "Prision domiciliaria"],
                :category=>"police"
            },
            {
                :document=>"Obama ordenó que EE.UU. acoja a 10 mil refugiados sirios El presidente de Estados Unidos, Barack Obama, ordenó a su Gobierno que inicie los preparativos para poder acoger al menos a 10.000 refugiados sirios durante el nuevo año fiscal, que empieza este 1 de octubre, anunció este jueves la Casa Blanca.Nota Relacionada: Argentina recibió más de 100 refugiados sirios desde 2014 El portavoz de la Casa Blanca, Josh Earnest, hizo el anuncio en su conferencia de prensa diaria, un día después de que el secretario de Estado de EE.UU., John Kerry, dijera que su país está comprometido a acoger a más refugiados sirios para responder a la crisis migratoria que está afectando a Europa, informó la agencia EFE.En el marco del conflicto, el grupo terrorista Estado Islámico (EI) señaló que los refugiados sirios que huyen a Europa cometen un grave pecado porque en esas tierras de los cruzados rigen las leyes del ateísmo y la indecencia.En la edición de septiembre de su revista Dabiq, el EI critica a los sirios y libios que arriesgan sus vidas y sus almas y abandonan voluntariamente la patria del islam por la patria de los infieles.Los yihadistas señalan que en Europa y EEUU los niños están bajo la constante amenaza del sexo, la sodomía, las drogas y el alcohol.Apuntan que, aunque no caigan en el pecado, es probable que olviden el lenguaje del Corán, el árabe, lo que hace más difícil que regresen a la religión (islam) y sus enseñanzas.El EI se muestra especialmente duro con aquellos que huyen de su autoproclamado califato, que abarca territorio sirio e iraquí, después de asegurar que la mayoría de las familias escapan de zonas controladas por el régimen sirio o por los kurdos.Cientos de miles de personas huyeron de los conflictos que azotan Oriente Medio y de la represión del EI, en especial de Siria, para buscar refugio en Europa.La Organización Internacional de las Migraciones (OIM) informó hace dos días de que más de 2.760 inmigrantes han muerto en lo que va de año en su intento de cruzar el Mediterráneo.",
                :keywords=>["Refugiados", " EEUU"],
                :category=>"world"
            },
            {
                :document=>"Sufre Boca: Pablo Pérez se desgarró y no estará en el Superclásico A sólo días del cruce vital ante River en un nuevo Superclásico por el campeonato local, Rodolfo Arruabarrena pierde a una de sus piezas clave: Pablo Pérez se desgarró durante el entrenamiento de este jueves y debió abandonar la práctica. Horas después, se confirmó que la lesión es un desgarro en la pierna derecha, por lo que no podrá estar el próximo domingo ante River en el Monumental.Nota Relacionada: Tevez y Gago llegaron tarde a la práctica de Boca pensando en el SuperclásicoPara reemplazar al mediocampista ofensivo, el entrenador de Boca eligió al uruguayo Nicolás Lodeiro, que hoy se sumó a los entrenamientos tras su convocatoria a la selección de su país. El equipo que pensó Arruabarrena para un nuevo Superclásico sería: Agustín Orion; Gino Peruzzi, Fernando Tobio, Daniel Díaz, Luciano Monzón (esperan que Nicolás Colazo se recupere de sus molestias físicas); Marcelo Meli, Cristian Erbes o Rodrigo Bentancur, Fernando Gago, Nicolás Lodeiro; Sebastián Palacios y Carlos Tevez.",
                :keywords=>["Superclasico", "Boca River", " futbol"],
                :category=>"entertainment"
            },
            {
                :document=>"Cristina comparte un almuerzo privado con Lula da Silva en la Casa Rosada La presidenta Cristina Kirchner recibe este jueves en la Casa de Gobierno al ex jefe de Estado de Brasil, Luiz Inácio Lula da Silva, quien se encuentra desde ayer de visita en nuestro país.Nota Relacionada: Cristina Kirchner, sobre Niembro: La oposición tiene el choripán de oro: es el más caro de la historiaTras una breve reunión, la jefa de Estado invitó a su ilustre visitante a compartir en el comedor presidencial un almuerzo privado durante el cual pasarán revista a la situación de la región, del cual participa además el embajador del país vecino, Everton Vieira Vargas.La Presidenta recibió a las 13.25 a Lula en su despacho de la Casa Rosada, consignaron fuentes oficiales.La mandataria se reunió con Lula luego del acto que ayer compartieron junto al candidato presidencial del oficialismo, Daniel Scioli, en ocasión de la inauguración de una Unidad de Pronta Atención (UPA) en la localidad bonaerense de José C. Paz. Da Silva se encuentra en el país para participar durante la semana de distintas actividades de apoyo a Scioli de cara a las elecciones de octubre.",
                :keywords=>["Cristina y Lula", " Lula da Silva"],
                :category=>"politics"
            },
            {
                :document=>"¿Qué le pasa a Jorge Rial? Tuvo una recaída de la neumonía y no puede trabajar Jorge Rial, hace dos o tres semanas, tuvo un principio de neumonía leve que estaba alojada sólo en una parte del pulmón. Si bien se había recuperado, se fue de viaje con su pareja, Agustina Kämpfer, pero ahora tuvo una recaída y está en cama. El conductor escribió un mensaje vía Twitter y confirmó su situación. Buen día. Lo que queda de mi los saluda. Ahora entiendo a los que me avisaban sobre la recaída de una neumonía. Era esto., expresó Rial. En Intrusos explicaron que está tomando antibióticos y que debe hacer reposo estricto, a diferencia de la vez pasada que pudo negociar con los médicos ir a cumplir con sus trabajos y después volver a la cama. En Desayuno Americano invitaron públicamente a Kämpfer al programa y mostraron al aire un mensaje que mandó la periodista a la producción: Hola, J mañana no va a ir a la radio porque no está bien de salud y me voy a quedar a cuidarlo. Decile a Pamela que gracias por la invitación, que lo pasemos. Besos. EmbedBuen día. Lo que queda de mi los saluda. Ahora entiendo a los que me avisaban sobre la recaída de una neumonía. Era esto.— JORGE RIAL (@rialjorge) septiembre 10, 2015",
                :keywords=>["Jorge Rial"],
                :category=>"entertainment"
            },
            {
                :document=>"Crimen en el country Martindale: abogada de Farré se sacó los zapatos para escapar de él La abogada que acompañaba a Fernando Farré el día que asesinó a su esposa Claudia Schaefer en el country Martindale, de Pilar, declaró que al darse cuenta de que el ex gerente estaba apuñalando a su mujer, se sacó las zapatos para correr más rápido porque pensó que su cliente salía del vestidor y continuaba la matanza con todos los que estaban en la casa. Fuentes judiciales informaron el jueves a Télam que la abogada Andrea Verónica Frencia (25) declaró ayer ante la fiscal de Pilar a cargo de la causa, Carolina Carballido, para ampliar sus dichos, ya que fue una de las dos testigos presenciales del hecho y sólo había realizado una breve declaración en la comisaría, porque el mismo día del crimen tuvo que viajar por la noche a Europa. Ya de regreso de ese viaje, Frencia se presentó el miércoles en la Unidad Funcional de Instrucción (UFI) Especializada en Violencia de Género de Pilar, donde se la notó muy afectada por lo que le tocó presenciar aquel 21 de agosto, a tal punto que tuvo una crisis de angustia en medio de su declaración y para poder concluir tuvo que ser asistida por el psicólogo de la fiscalía, según contaron las fuentes. La abogada explicó que ella fue al country Martindale en el mismo auto que Farré y su madre, Nenina Castro, y que llegaron alrededor de las 10 de la mañana. Según la joven abogada, durante el viaje Farré no estaba nervioso ni hizo ningún comentario agresivo contra su esposa Schaefer, que esa mañana iba a llegar al country para, como parte del acuerdo de la separación, retirar su ropa y pertenencias de la casa que allí alquilaban. En la hora que tuvieron de espera hasta que arribaron Schaefer y su abogado Carlos Quirno, Frencia contó que Farré entraba y salía de la casa y que se movió por distintos ambientes aunque ella no prestó atención por dónde. Lo que sí ratificó la abogada es que el propio Farré les preparó a ella y a su madre un té, lo que para la fiscalía es una prueba de que en algún momento, antes de que llegara su esposa, el imputado estuvo en la cocina y allí pudo haber agarrado los dos cuchillos que había en un set de cinco, en un taco de madera, y que fueron empleados para cometer el asesinato. Frencia recordó que cuando llegó Schaefer, ella y el abogado Quirno salieron por la puerta de servicio al costado de la casa, para dialogar sobre cuestiones del divorcio. Al igual que contó el abogado Quirno, Frencia también ratificó que no hubo ninguna discusión previa entre Farré y su esposa, sino que se dieron cuenta de que algo malo pasaba cuando empezaron a escuchar los gritos de Castro que le decía a su hijo: ¡Pará, pará!. Ambos abogados entraron a la casa, advirtieron que Farré estaba encerrado en el vestidor atacando a su esposa y todos salieron de la casa. Mientras Quirno y la madre de Farré fueron a ver lo que ocurría a través de la ventana del vestidor, Frencia relató que ella salió corriendo de la casa. Incluso contó que se sacó los zapatos para poder correr con mayor facilidad porque pensó que Farré salía del vestidor y continuaba la matanza con ellos, dijo a Télam una fuente judicial.",
                :keywords=>["Farre"],
                :category=>"police"
            },
            {
                :document=>"En el Prode, ponele una cruz a River Marcelo Gallardo habló en la previa del Superclásico. De Boca, de River y, por supuesto, de Milton Casco, el lateral que acaba de llegar y del que varios especulan que será titular ante el Xeneize. Eso sí, el DT negó que ya lo tenga definido. Además, remarcó, en declaraciones a Cómo te va? cómo se vive esta semana previa al Superclásico: “Más alla de la importancia del rival, cada partido lo preparamos de la misma manera”, aseguró Gallardo. El Muñeco también negó que su equipo busqué ganar el domingo como sea: “Se dice que hay que ganar como sea,a mi me gusta siendo superior al rival en todos los aspectos, se plantó el DT Millonario, quién también tiró una frase que da que pensar: Antes de los partidos me gusta verle la cara a los jugadores. Además, reconoció: Estamos obligados a ser flexibles, en un plantel hay cambios permanentemente y amplió que más allá que me gusta jugar de una determinada manera, tengo algunos futbolistas que están en condiciones de aplicarla y otros que no”. De todas maneras, el DT de River aseguró que el equipo que enfrentará a Boca no va a variar demasiado a lo que nosotros venimos planteando” y subrayó que Más allá de los nombres, River tiene una idea de juego acentuada”. Por último, amplió: En base al entrenamiento del sábado, comunicaré quienes van a jugar contra Boca” Flores para el goleador AlarioSobre el rendimiento de Lucas, el DT del Millo se deshizo en elogios: no es para menos, el ex Colón marcó dos goles clave en la Copa Libertadores y el pasado fin de semana firmó su primer hat-trick para el Millo, ante Chicago: Hay que valorar que este grupo permite que un jugador se adapte como lo hizo Alario” “Alario está demostrando sus cualidades y su personalidad. Se fue ganando un lugar”, expresó sobre el jugador que llegó de Colón. ¿Se pone o no el Casco?Gallardo negó que ya haya decidido jugar con Milton ocupando el andarivel izquierdo o no. Todavía no tuve posibilidad de ver a Casco, nos encontraremos hoy en el entrenamiento, aventuró el DT que, igualmente, dejó en claro que ya sabe que si decide ponerlo, el jugador está dispuesto: Yo ya se la respuesta de Casco, me lo dijo por teléfono. Iré evaluándolo en la semana. “Casco tiene chances de jugar el Superclásico. No tenemos un reemplazante natural a Vangioni”, reconoció el DT del Millo, que, además, elogió a su nuevo jugador: Junto a Vangioni y Más, Casco es uno de los 2 o 3 mejores laterales del país. Jugale al PRODE, Muñe.Como Bauza y Cocca, el DT de River también bromeó con el tradicional juego de pronósticos. En el PRODE le pongo una cruz a River, aseguró, repleto de confianza y, de cara al futuro, manifestó una realidad: Sabemos que se nos van a ir jugadores, por eso ya estamos pensando en el recambio.",
                :keywords=>["Superclasico"],
                :category=>"entertainment"
            },
            {
                :document=>"Provincias petroleras quieren mantener subsidio para productoras Por Cledis Candelaresi Las provincias petroleras presentaron al candidato presidencial del Frente Para la Victoria, Daniel Scioli, un documento en el que proponen que el barril de petróleo se siga pagando en Argentina 77 dólares, aunque en el mundo esté por debajo de los 50. Ese grupo de estados del interior también reclaman infraestructura para desarrollar la actividad petrolera y apuestan a que, de acceder a la presidencia, el gobernador bonaerense jerarquice el tema creando un ministerio de Energía. En su comando podría ubicarse el neuquino Jorge Sapag.",
                :keywords=>["Frente Para la Victoria", " Scioli", " Elecciones", " Provincias petroleras"],
                :category=>"politics"
            }
        ]
      end


      let(:req_params) do
        {
            body: {
                corpus: corpus,
                metadata: {
                    nmb_of_centroids: nmb_of_centroids
                }
            }
        }
      end

      let(:nmb_of_centroids) { 10 }


      it "returns http status ok" do
        pending
        subject
        expect(response).to have_http_status(:ok)
        puts (JSON.parse(response.body)["result_set"])
      end

    end

  end

end