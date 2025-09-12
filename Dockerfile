# Use official Python 3.12 image
FROM python:3.12-slim

# Set working directory inside the container
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y wget unzip xvfb

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable

# Install ChromeDriver
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d. -f1)
RUN LATEST=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION)
RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$LATEST/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip -d /usr/local/bin/
RUN chmod +x /usr/local/bin/chromedriver

# Copy requirements.txt first (for caching layers)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port 8000
EXPOSE 8000

# Run the app (change app.py to your entrypoint file)
CMD ["python", "server.py"]

