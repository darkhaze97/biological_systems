import './App.css';
import { Route, Switch, useHistory } from "react-router-dom";
import InteractionPage from "./pages/InteractionPage";
import MainPage from "./pages/MainPage";
import InteractionResultPage from "./pages/InteractionResultPage";
import SpecificInteractionPage from "./pages/SpecificInteractionPage";
import ConceptPage from "./pages/ConceptPage";
import ConceptResultPage from "./pages/ConceptResultPage";
import SpecificConceptPage from "./pages/SpecificConceptPage"

function App() {

  const history = useHistory();

  return (
    <div>
      <div class="App">
        <em>
          <strong>
            <h1 class="test"> Bint </h1>
          </strong>
        </em>
        <button onClick={() => history.push('/')}>
          Home
        </button>
        <button onClick={() => history.push('/interactions')}>
          Interaction
        </button>
        <button onClick={() => history.push('/concepts')}>
          Concept
        </button>
      </div>

      
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
          component={InteractionResultPage}/>;
        <Route
          exact
          path='/interactions/results/specific'
          component={SpecificInteractionPage}/>;
        <Route
          exact
          path='/concepts'
          component={ConceptPage}/>;
        <Route
          exact
          path='/concepts/results/all'
          component={ConceptResultPage}/>;
        <Route
          exact
          path='/concepts/results/specific'
          component={SpecificConceptPage}/>;
      </Switch>

    </div>
  );
}

export default App;
