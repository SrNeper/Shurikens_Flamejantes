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
    <$> areq textField "Descrição: " Nothing

getPerguntaR :: Handler Html
getPerguntaR = do 
    (widget,_) <- generateFormPost formPergunta
    msg <- getMessage
    defaultLayout $ 
        [whamlet|
            $maybe mensa <- msg 
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE PERGUNTA
            
            <form method=post action=@{PerguntaR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]
        
postPerguntaR :: Handler Html
postPerguntaR = do 