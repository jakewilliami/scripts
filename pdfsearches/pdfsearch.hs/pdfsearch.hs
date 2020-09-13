import Pdf.Document

main =
  withPdfFile "/Users/jakeireland/Desktop/2008.09004.pdf" $ \pdf ->
    encrypted <- isEncrypted pdf
    when encrypted $ do
      ok <- setUserPassword pdf defaultUserPassword
      unless ok $
        fail "need password"
    doc <- document pdf
    catalog <- documentCatalog doc
    rootNode <- catalogPageNode catalog
    count <- pageNodeNKids rootNode
    print count
    -- the first page of the document
    page <- pageNodePageByNum rootNode 0
    -- extract text
    txt <- pageExtractText page
    print txt
    ...

-- https://github.com/Yuras/pdf-toolbox