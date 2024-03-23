import asyncio
import os

from git import Repo
from telegram import Bot

repo = Repo.clone_from(os.getenv('URL'), 'pkg')
message = repo.commit(os.getenv('COMMIT')).message

bot = Bot(os.getenv('TELEGRAM_TOKEN'))
asyncio.run(
    bot.send_message(
        getenv('TELEGRAM_TO'),
        f'v{getenv("COMMIT")} build succeeded\nCommit message: {message}\nSummary: {os.getenv("SUMMARY_URL")}'
    ))
