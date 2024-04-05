import asyncio
import time

def run3():
    print('Hello World 3')
    time.sleep(3)

def run2():
    print('Hello World 2')

async def main():
    try:
        async with asyncio.timeout(2):
            await asyncio.create_subprocess_exec('python3.11', 'script.py')
    except asyncio.TimeoutError:
        print('Timeout')
        run2()
    
if __name__ == '__main__':
    asyncio.run(main())

