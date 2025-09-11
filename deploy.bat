@echo off
echo 🚀 Deploying AI Voice Assistant to Vercel...

REM Check if Vercel CLI is installed
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Vercel CLI...
    npm install -g vercel
)

REM Deploy to Vercel
echo Deploying to Vercel...
vercel --prod

echo ✅ Deployment complete!
echo Your app should be live at the URL shown above.
