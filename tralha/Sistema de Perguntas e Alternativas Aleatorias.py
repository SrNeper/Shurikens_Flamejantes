import random

perguntas = (

'Qual desses esportes, você faria?',                          #0
'Se pudesse ir para um desses lugares, para qual você iria?', #1
'Que comida é capaz de despertar o ninja em você?',           #2
'Escolha uma arma!',                                          #3
'Qual desses poderia ser o seu jeito ninja?'                  #4

)

alternativas = (

  {#00 - Pergunta: Esporte
    #Valor        -> Resposta
    0:' Alpinismo ',             #Naruto    
    1:' Formula 1 ',             #Jiraya
    2:' Esqui no Gelo ',         #SubZero
    3:' Caça ',                  #GrayFox

  },
  
  {#01 - Pergunta: Lugar
    #Valor        -> Resposta
    0:' Amazonia ',              #Naruto
    1:' Provincia de Iga ',      #Jiraya
    2:' Alaska ',                #SubZero
    3:' Vietnã ',                #GrayFox

  },

  {#02 - Pergunta: Comida
    #Valor        -> Resposta
    0:' Ramen ',                  #Naruto
    1:' Arroz Doce ',             #Jiraya
    2:' Sorvete ',                #SubZero
    3:' Picadinho de Carne ',     #GrayFox

  },
  
  {#03 - Pergunta: Arma
    #Valor        -> Resposta
    0:' Kunai ',                  #Naruto
    1:' Shuriken ',               #Jiraya
    2:' Meus Punhos ',            #SubZero
    3:' Katana ',                 #GrayFox

  },
  
  {#04 - Pergunta: Jeito Ninja!
   #Valor        -> Resposta     
    0:' Eu nunca volto atrás na minha palavra ',       #Naruto
    
    1:' Não tenho misericordia dos meus inimigos. ',   #Jiraya
    
    2:' Meu objetivo será alcançado,'+ 
      ' não importa quem fique no meu caminho. ',      #SubZero
    
    3:' Todos os problemas podem ser'+ 
      ' resolvidos em um campo de batalha ',           #GrayFox
     
  },
)


def getRandomNumberList(start, end):

  '''Essa função retorna uma lista de nº inteiros,
     unicos e aleatorios.

     Ex: (3,5,8) onde 3 é o start e 8 é o end.'''

  number_list = list()

  while len(number_list) <= end:
    n = random.randint(start,end)

    if n not in number_list:
      number_list.append(n)
  
  else:

    return number_list
    number_list.clear()

def countPoints(opc, r, gabarito):

  ''' Com a resposta "r", essa função 
  confere o "gabarito" e marca quantos pontos
  o jogador fez. Além disso ela também valida 
  a opção digitada pelo usuario é valida. '''

  pontos = 0

  while True:

    if r not in opc:
      print(f'{r}, não é uma opção valida. \ndigite: ', opc)
      r = input()
    else:

      aux = int(opc.index(r))

      #Soma +1 pq o indice das alternativas começa em Zero
      pontos = gabarito[aux]+1  

      #print('\nGabarito', gabarito, "Aux ", aux)
      #print('\npontos dessa questão: ', pontos)
      break
  
  return pontos


def showNinja(pontos):    

  print("\nO ninja que mais parece com você é.... ")

  if pontos <= 5:
    print(f'''\n
    
    Naruto:
    "Aquele que trabalha duro pode superar um gênio, mas de nada
    adianta trabalhar duro se você não confia em você mesmo…"
    
    \n
    ''')
  
  elif pontos <= 10:
    print(f'''\n
    
    Jiraya:
    "Não te perdoou!"

    \n
    ''')

  elif pontos <= 15:
    print(f'''\n
    
    SubZero:
    "Tá frio aqui... me dá um abraço?"

    \n
    ''')
  
  else:
    print(f'''\n
    
   Gray Fox:
   "O conflito está em nosso sangue. Não podemos negar.
    Eu nasci no campo de batalha ... E vou morrer no campo de batalha.
    Tudo que posso fazer é lutar, Snake ... tudo que posso fazer é lutar."

    \n
    ''')
#------------------------------------x-----------------------------------#


#Ordenando Perguntas Aleatoriamente
ord_Perguntas = getRandomNumberList(0,4)

somaPontos = 0

for i in range(len(ord_Perguntas)):
  
  n = ord_Perguntas[i]

  print('\n', perguntas[n], '\n')

  #Qual foi a pergunta selecionada?
  id_Pergunta = perguntas.index(perguntas[n])
  cont = 0

  ord_Alternativas = getRandomNumberList(0,3)

  #Listando Alternativas:
  while cont<=3:

    #Opções validas:
    opc = 'abcd'

    x = ord_Alternativas[cont]

    print(f' {opc[cont]}){alternativas[id_Pergunta][x]}')
    cont += 1
  
  else:
    res = input('\nDigite uma das opções acima: \n')
    somaPontos  += countPoints(opc, res, ord_Alternativas)

showNinja(somaPontos)