import asyncio
from deriv_api import DerivAPI

# --- CLEANING THE TOKEN ---
raw_token = 'LFEbvxMs11TzSfp'
MY_TOKEN = raw_token.strip() 
MY_APP_ID = '132104' 

async def test_connection():
    # Attempting connection with your App ID
    api = DerivAPI(app_id=MY_APP_ID)
    try:
        print(f"🔗 Testing Token: {MY_TOKEN}")
        await api.authorize(MY_TOKEN)
        print("✅ SUCCESS! The token is valid and connected.")
        
        # Immediate small trade test
        print("--- Attempting $0.35 Trade ---")
        await api.buy({
            "buy": 1,
            "price": 0.35,
            "parameters": {
                "amount": 0.35,
                "basis": 'stake',
                "contract_type": 'DIGITOVER',
                "currency": 'USD',
                "duration": 1,
                "duration_unit": 't',
                "barrier": '5',
                "symbol": '1HZ100V'
            }
        })
        print("🚀 TRADE PLACED SUCCESSFULLY!")

    except Exception as e:
        print(f"🛑 Error: {e}")
        if "invalid" in str(e).lower():
            print("💡 Suggestion: Try using App ID '1089' instead of '132104' in the code above.")
    finally:
        await api.disconnect()

asyncio.run(test_connection())
