rm *.pem
rm *.srl
# 1. Generate CA's private key and self-signed certificate
# Remove -nodes to encrypt private key
openssl req -x509 -newkey rsa:4096 -days 365 -keyout ca-key.pem -out ca-cert.pem -subj "/C=US/ST=California/L=Torrance/O=TVUSA/OU=IT/CN=Long John Silver/emailAddress=longjohnsilver@gmail.com"

echo "CA's self-signed certificate"
echo
openssl x509 -in ca-cert.pem -noout -text

# 2. Generate web server's private key and certificate signing request(CSR).
# Remove -nodes to encrypt private key
openssl req -newkey rsa:4096 -days 365 -keyout server-key.pem -out server-req.pem -subj "/C=US/ST=Origan/L=Portland/O=PC Book/OU=Computer/CN=*.pcbook.com/emailAddress=pcbook@gmail.com"

# 3. Use CA's private key to sign web server's CSR and get back signed certificate.
openssl x509 -req -in server-req.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile server-ext.cnf

echo
echo "Server's certificate"
echo
openssl x509 -in server-cert.pem -noout -text

# 4. Verify Certificate
echo
echo
echo
openssl verify -CAfile ca-cert.pem server-cert.pem
