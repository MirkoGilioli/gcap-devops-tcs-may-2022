def test_orders_page(client):
    '''
    GIVEN a Flask application
    WHEN  the '/orders' page is hit with GET method
    THEN check that 200 is returned
    '''
    resp = client.get('/orders')
    assert resp.status_code == 200
    assert b'Welcome this is the orders Page' in resp.data

def test_help_methodNotAllowed(client):
    '''
    GIVEN a Flask application
    WHEN  the '/orders' page is hit with POST method
    THEN check that 405 is returned (Method Not Allowed)
    '''
    resp = client.post('/')
    assert resp.status_code == 405