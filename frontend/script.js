let lastCalculation = null;

const apiUrl = 'http://localhost:4566/restapis/exnnx3ipj1/prod/_user_request_';

async function add() {
    const number1 = document.getElementById('number1').value;
    const number2 = document.getElementById('number2').value;

    console.log('Sending request to API Gateway');
    try {
        const response = await fetch(`${apiUrl}/add`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ number1: parseFloat(number1), number2: parseFloat(number2) }),
        });

        console.log('Response received:', response);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        console.log('Data:', data);
        document.getElementById('result').innerText = `Result: ${data.result}`;
        lastCalculation = { number1: parseFloat(number1), number2: parseFloat(number2), result: data.result };
        document.getElementById('saveButton').style.display = 'block';
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('result').innerText = `Error: ${error.message}`;
        document.getElementById('saveButton').style.display = 'none';
    }
}

async function saveResult() {
    if (!lastCalculation) {
        console.error('No calculation to save');
        return;
    }

    console.log('Sending save request to API Gateway');
    console.log('Data being sent:', JSON.stringify(lastCalculation));

    try {
        const response = await fetch(`${apiUrl}/save`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(lastCalculation),
        });

        console.log('Save response received:', response);

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        console.log('Save response data:', data);

        if (data.saved) {
            document.getElementById('saved').innerText = 'Result saved to DynamoDB!';
            document.getElementById('saveButton').style.display = 'none';
        } else {
            document.getElementById('saved').innerText = 'Failed to save result.';
        }
    } catch (error) {
        console.error('Error saving result:', error);
        document.getElementById('saved').innerText = `Error: ${error.message}`;
    }
}
