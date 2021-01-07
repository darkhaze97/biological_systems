import logo from './logo.svg';
import './App.css';
import { Route, Switch, useHistory } from "react-router-dom";
import InteractionPage from "./pages/InteractionPage";
import MainPage from "./pages/MainPage";

function App() {

  const history = useHistory();

  return (
    <div className="App">
      <em>
        <strong>
          <h1> Bint </h1>
        </strong>
      </em>
      <button onClick={() => history.push('/')}>
        Home
      </button>
      <button onClick={() => history.push('/interactions')}>
        Interaction
      </button>
      <Switch>
        <Route exact path='/'>
          <MainPage />
        </Route>
        <Route exact path='/interactions'>
          <InteractionPage />
        </Route>
      </Switch>

    </div>
  );
}

export default App;
