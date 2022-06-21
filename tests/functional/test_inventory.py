def test_inventory_page(client):
    '''
    GIVEN a Flask application
    WHEN  the '/invetory' page is hit with GET method
    THEN check that 200 is returned
    '''
    resp = client.get('/inventory')
    assert resp.status_code == 200
    assert b'Welcome this is the inventory Page' in resp.data

def test_inventory_methodNotAllowed(client):
    '''
    GIVEN a Flask application
    WHEN  the '/inventory' page is hit with POST method
    THEN check that 405 is returned (Method Not Allowed)
    '''
    resp = client.post('/')
    assert resp.status_code == 405