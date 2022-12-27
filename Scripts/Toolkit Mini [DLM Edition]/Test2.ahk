#NoEnv
#Warn
#SingleInstance, Force

Base64ImageData := "
( LTrim Join
  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
)" 

Gui, Add, ActiveX, x50 y10 w300 h300 vDoc, HtmlFile
Doc.Write( "<img src=""data:image/png;base64, " Base64ImageData """/>" )
Gui, Show,, ActiveX Base64 Image Test
Return