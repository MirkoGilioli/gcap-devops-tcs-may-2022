def test_help_page(client):
    '''
    GIVEN a Flask application
    WHEN  the '/help' page is hit with GET method
    THEN check that 200 is returned
    '''
    resp = client.get('/help')
    assert resp.status_code == 200
    assert b'Welcome this is the help Page' in resp.data

def test_home_methodNotAllowed(client):
    '''
    GIVEN a Flask application
    WHEN  the '/help' page is hit with POST method
    THEN check that 405 is returned (Method Not Allowed)
    '''
    resp = client.post('/')
    assert resp.status_code == 405