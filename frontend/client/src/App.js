import './App.css';
import { Route, Switch, useHistory } from "react-router-dom";
import InteractionPage from "./pages/InteractionPage";
import MainPage from "./pages/MainPage";
import ResultPage from "./pages/ResultPage";
import SpecificResultPage from "./pages/SpecificResultPage"

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
        <Route
          exact
          path='/'
          component={MainPage}
        />
        <Route 
          exact 
          path='/interactions' 
          component={InteractionPage}/>;
        <Route 
          exact 
          path='/interactions/results/all'
          component={ResultPage}/>;
        <Route
          exact
          path='/interactions/results/specific'
          component={SpecificResultPage}/>;
      </Switch>

    </div>
  );
}

export default App;
