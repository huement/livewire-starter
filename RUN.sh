#!/usr/bin/env bash

echo ""
echo " Running Laravel Sail "
echo " Huement.com Blog Dev Server"
echo ""
echo " MUST run Vite via npm for js / scss"
echo " A: 'pm2 start \"./vendor/bin/sail npm run dev\" --name huementBlog'"
echo " B: 'snpm run dev'"
echo ""
echo " Optionally run the Queue for emails and jobs"
echo " 'sartisan queue:work -v'"
echo ""

./vendor/bin/sail up -d
