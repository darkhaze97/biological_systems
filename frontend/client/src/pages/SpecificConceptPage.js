import { Button } from "@material-ui/core"
import axios from "axios"

const SpecificConceptPage = (props) => {
    const data = props.location.state.response
    console.log(data)
    const conceptInfo = data.conceptInfo
    const conceptMolecules = data.conceptMolecules
    const id = 0
    axios.post("http://127.0.0.1:8080/concepts/results/molecules/information", {id})
    .then((response) => {
        console.log(response)
    // props.history.push('/concepts/results/specific', {response: response.data})
    })
    .catch((err) => {})

    const handleSubmit = (event, id) => {
        axios.post("http://127.0.0.1:8080/concepts/results/molecules/information", {id})
        .then((response) => {
            console.log(response)
        // props.history.push('/concepts/results/specific', {response: response.data})
        })
        .catch((err) => {})
    }




    const deconstructConceptInfo = () => {
        return (
            <div>
                <h1>
                    {conceptInfo.concept_name}
                </h1>
                <div>
                    {conceptInfo.info}
                </div>
            </div>
        )
    }

    const deconstructConceptMolecules = () => {
        return (
            conceptMolecules.map(function (item, index) {
                return (
                    <Button>
                        {Object.entries(item).map(([columnName, info]) => {
                            return (
                                <h4>
                                    {columnName}: {info}
                                </h4>
                            )
                        })}
                    </Button>

                )

            })
        )
    }

    return (
        <div class="App">
            <div class="component-padding">
                {deconstructConceptInfo()}
            </div>
            <div class="component-padding">
                <p>
                    Molecule contributions
                </p>
                {deconstructConceptMolecules()}
            </div>
        </div>

    )
}

export default SpecificConceptPage