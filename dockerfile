# 1. Imagem Base
# Começa com a mesma imagem Alpine que sabemos que funciona.
FROM alpine:latest

# 2. Instala as dependências do S.O. (Python, pip)
#    (Não precisamos mais do 'git' ou 'openssh' 
#     porque vamos copiar o código em vez de clonar)
RUN apk update && apk add \
    python3 \
    py3-pip 

# 3. Cria a pasta para o aplicativo dentro do contêiner
WORKDIR /app

# 4. Copia a lista de bibliotecas PRIMEIRO
#    Isto é um truque de cache do Docker para builds mais rápidos
COPY requirements.txt .

# 5. Instala as bibliotecas Python
#    (Note: Não precisamos de 'venv'! O contêiner JÁ É o isolamento.)
RUN pip3 install -r requirements.txt

# 6. Copia TODO o resto do seu código (seu_app.py, etc.)
#    O "." significa "copie tudo daqui" para o WORKDIR (/app)
COPY . .

# 7. Expõe a porta que o Streamlit usa
EXPOSE 8501

# 8. O comando para executar quando o contêiner iniciar
CMD ["python3", "-m", "streamlit", "run", "seu_app.py", "--server.port=8501", "--server.address=0.0.0.0"]