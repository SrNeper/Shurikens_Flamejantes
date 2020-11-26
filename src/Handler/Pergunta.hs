{-# LANGUAGE NoImplicitPrelude #-} 
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Pergunta where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Stactus
import Database.Persist.Postgresql
--import Database.Esqueleto
import Data.Text (Text, concat)

-- renderDivs
formPergunta :: Form Pergunta
formPergunta = renderBootstrap $ Pergunta
    <$> areq textField "Escreva uma pergunta para adicionar a lista: " Nothing

getPerguntaR :: Handler Html
getPerguntaR = do 
    (widget,_) <- generateFormPost formPergunta
    msg <- getMessage
    defaultLayout $ do
        addStylesheet (StaticR css_animate_css)
        addStylesheet (StaticR css_icomoon_css)
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_superfish_css)
        addStylesheet (StaticR css_style_css)
        addScript (StaticR js_jquery_js)
        addScript (StaticR js_modernizr_js)
        addScript (StaticR js_easing_js)
        addScript (StaticR js_bootstrap_js)
        addScript (StaticR js_waypoints_js)
        addScript (StaticR js_stellar_js)
        addStylesheetRemote "https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700,300"
        toWidget $(juliusFile "templates/julius/hoverIntent.julius")
        toWidget $(juliusFile "templates/julius/superfish.julius")
        toWidget $(juliusFile "templates/julius/main.julius")        
        $(whamletFile "templates/pergunta.hamlet")        

postPerguntaR :: Handler Html
postPerguntaR = do 
    ((result,_),_) <- runFormPost formPergunta
    case result of 
        FormSuccess pergunta -> do 
            runDB $ insert pergunta 
            setMessage [shamlet|
                <div>
                    Pergunta incluida
            |]
            redirect PerguntaR
        _ -> redirect HomeR

getListaQuestoesR :: Handler Html
getListaQuestoesR = do
    perguntas <- runDB $ selectList [] [Asc PerguntaId]
    alternativas <- runDB $ selectList [] [Asc AlternativaDescricao]
    
    defaultLayout $ do
        setTitle "Listagem de Questões"
        addStylesheet (StaticR css_bootstrap_css)
        $(whamletFile "templates/list-questions.hamlet")

getQuizPerguntaR :: Handler Value
getQuizPerguntaR = do
    perguntas <- runDB $ selectList [] [Asc PerguntaId]
    returnJson (map entityVal perguntas)