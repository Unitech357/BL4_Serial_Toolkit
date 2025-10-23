from pydantic import BaseModel
from typing import List

class DecodeRequest(BaseModel):
    serial: str

class BulkDecodeRequest(BaseModel):
    serials: List[str]
