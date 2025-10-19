# 1. Imagem Base
FROM alpine:latest

# 2. Instala as dependências do S.O.
#    ADICIONAMOS 'python3-venv'
RUN apk update && apk add \
    python3 \
    py3-pip

# 3. Cria o ambiente virtual
#    Vamos criar um venv "global" para o contêiner em /opt/venv
RUN python3 -m venv /opt/venv

# 4. A MÁGICA: Adiciona o venv ao PATH do sistema
#    Isso garante que qualquer comando 'python' ou 'pip' 
#    daqui para frente use o venv automaticamente.
ENV PATH="/opt/venv/bin:$PATH"

# 5. Cria a pasta de trabalho
WORKDIR /app

# 6. Copia a lista de bibliotecas
COPY requirements.txt .

# 7. Instala as bibliotecas (agora DENTRO do venv)
#    (Usamos 'pip' e 'python' agora, pois eles vêm do PATH do venv)
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# 8. Copia o resto do seu código
COPY . .

# 9. Expõe a porta
EXPOSE 8501

# 10. O comando para executar (agora usará o Python/Streamlit do venv)
CMD ["streamlit", "run", "main.py", "--server.port=8501", "--server.address=0.0.0.0"]