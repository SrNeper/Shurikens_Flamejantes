{-# LANGUAGE NoImplicitPrelude #-} 
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
-- import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

-- renderDivs
formLogin :: Form (Text, Text)
formLogin = renderBootstrap $ (,)
    <$> areq emailField "Email: " Nothing
    <*> areq passwordField "Digite novamente: " Nothing
    
getEntrarR :: Handler Html
getEntrarR = do
    (widget, _) <- generateFormPost formLogin
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
        $(whamletFile "templates/login.hamlet")

postEntrarR :: Handler Html
postEntrarR = do 
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess (email,senha) -> do
            -- select * from usuario where email = digitado.email
            usuario <- runDB $ getBy (UniqueEmailRest email)
            case usuario of
                Nothing -> do
                    setMessage [shamlet|
                        <div>
                            E-mail N ENCONTRADO!
                    |]
                    redirect UsuarioR
                Just (Entity _ usu) -> do 
                    setSession "_NOME" (usuarioNome usu)
                    redirect HomeR
        _ -> redirect HomeR
        
postSairR :: Handler Html
postSairR = do 
    deleteSession "_NOME"
    redirect HomeR