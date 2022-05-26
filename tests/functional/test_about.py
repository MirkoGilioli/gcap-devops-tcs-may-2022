def test_about_page(client):
    '''
    GIVEN a Flask application
    WHEN  the '/about' page is hit with GET method
    THEN check that 200 is returned
    '''
    resp = client.get('/about')
    assert resp.status_code == 200
    assert b'Welcome this is the about Page' in resp.data

def test_about_methodNotAllowed(client):
    '''
    GIVEN a Flask application
    WHEN  the '/about' page is hit with POST method
    THEN check that 405 is returned (Method Not Allowed)
    '''
    resp = client.post('/about')
    assert resp.status_code == 405