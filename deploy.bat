@echo off
echo 🚀 Deploying AI Voice Assistant to Vercel...

REM Navigate to project directory (if not already there)
cd /d e:\Git\ES-GCEK\AI-Voice-Assistant-UI\ai_voice_assistant

REM Check if Flutter is available
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter not found! Please install Flutter and add it to PATH.
    pause
    exit /b 1
)

REM Check if Vercel CLI is installed
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Vercel CLI...
    npm install -g vercel
)

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean

REM Build for web with correct base href
echo 🔨 Building Flutter web app...
flutter build web --release --base-href /

REM Check if build was successful
if not exist "build\web\index.html" (
    echo ❌ Build failed! Check Flutter configuration.
    pause
    exit /b 1
)

REM Deploy to Vercel
echo 📤 Deploying to Vercel...
vercel --prod build/web

echo ✅ Deployment complete!
echo 🌐 Your app should be live at the URL shown above.
echo 📝 Don't forget to add environment variables in Vercel dashboard if needed.
