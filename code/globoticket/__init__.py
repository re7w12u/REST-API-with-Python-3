# Note: this code differs from the code
# shown during the course.
# This has been added to fix problems loading dotenv
import os

try:
    from dotenv import load_dotenv
except ImportError:
    from dotenv.main import load_dotenv


load_dotenv()
print(os.getenv("SQLALCHEMY_DATABASE_URL"))
