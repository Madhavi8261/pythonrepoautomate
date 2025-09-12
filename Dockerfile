# Use official Python 3.12 image
FROM python:3.12-slim

# Set working directory inside the container
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y wget unzip xvfb gnupg curl \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable

# Install matching ChromeDriver
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d. -f1) \
    && LATEST=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION}) \
    && wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/${LATEST}/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm /tmp/chromedriver.zip

# Copy requirements first (better cache)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code (server + Robot tests)
COPY . .

# Expose port 5000 (make sure server.py runs on this port)
EXPOSE 5000

# Run your backend server
CMD ["python", "server.py"]
