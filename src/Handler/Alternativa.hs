{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Alternativa where

import Import
-- import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

-- Puxa as perguntas 
perguntaCB = do
  rows <- runDB $ selectList [] [Asc PerguntaDescricao]
  optionsPairs $ 
      map (\r -> (perguntaDescricao $ entityVal r, entityKey r)) rows

-- Formulário das alternativas
formAlternativa :: Form Alternativa 
formAlternativa = renderBootstrap $ Alternativa
    <$> areq (selectField perguntaCB) "Pergunta: " Nothing
    <*> areq textField "Digite uma alternativa: " Nothing --testar
    <*> areq boolField "É a correta?: " Nothing

-- Subindo alternativas para o banco
postAlternativaR :: Handler Html
postAlternativaR = do
    ((result,_),_) <- runFormPost formAlternativa
    case result of
        FormSuccess alternativa -> do
            runDB $ insert alternativa
            setMessage [shamlet|
                <h2>
                    ALTERNATIVA INSERIDA COM SUCESSO
            |]
            redirect AlternativaR
        _ -> redirect HomeR

-- Pegar a alternativa do usuário
getAlternativaR :: Handler Html
getAlternativaR = do 
    (widget,_) <- generateFormPost formAlternativa
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
        $(whamletFile "templates/alternativa.hamlet")

-- Resposta do quiz
getQuizRespostaR :: Handler Value
getQuizRespostaR = do
    alternativas <- runDB $ selectList [] [Asc AlternativaId]
    returnJson (map entityVal alternativas)