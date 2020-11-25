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
    <*> areq textField "Alternativa: " Nothing --testar
    <*> areq boolField "É correta?: " Nothing
