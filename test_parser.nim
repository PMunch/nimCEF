import nc_parser, nc_xml_reader, nc_stream, nc_util, cef_types, nc_xml_object
import nc_zip_reader, os, nc_value

var parts: NCUrlParts
if ncParseUrl("http://admin:pass@www.myhost.net:8080/mypath/index.php?title=main_page", parts):
  for key, val in fieldPairs(parts):
    echo key, " : ", val
else:
  echo "NCParseUrl failed"

var url: string
if ncCreateUrl(parts, url):
  echo url
else:
  echo "ncCreateUrl failed"

echo ncFormatUrlForSecurityDisplay(url)
let mime = ncGetMimeType("jpg")
echo mime

let exts = ncGetExtensionsForMimeType("text/html")
for x in exts:
  echo x

let base64 = ncBase64Encode(url.cstring, url.len)
echo base64

echo ncBase64Decode(base64).getDataAsString()

let encuri = ncUriEncode(url, true)
echo encuri

echo ncUriDecode(encuri, false, NC_UU_ALL)

var stream = ncStreamReaderCreateForFile("resources" & DirSep & "spruce.xml")
assert(stream != nil)

var loadError: string
var xml = loadXml(stream, XML_ENCODING_UTF8, "", loadError)
if xml == nil:
  echo loadError
  quit(1)

var child = xml.findChild("spruce").findChild("description")
if child != nil:
  echo child.getAttributes()

var zs = ncStreamReaderCreateForFile("resources" & DirSep & "sample.zip")
assert(zs != nil)

var zip = ncZipReaderCreate(zs)
assert(zip != nil)

#bug cef_zip_reader::get_file_last_modified always returned with same result
discard zip.moveToFirstFile()
while true:
  echo "name: ", zip.getFileName()
  echo "size: ", zip.getFileSize()
  echo "modified: ", zip.getFileLastModified()
  if not zip.moveToNextFile(): break

discard zip.close()