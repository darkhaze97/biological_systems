import React from "react"
import axios from "axios"
import { Button } from "@material-ui/core"

const ResultPage = (props) => {
    const data = props.location.state.response
    console.log("Here is the prop!")
    console.log(data)

    data.forEach(function (item, index) {
        for (var key of Object.keys(item)) {
            console.log(key + " -> " + item[key])
            for (var key2 of Object.keys(item[key])) {
                console.log(key2 + " -> " + item[key][key2])
                item[key][key2].forEach(function (item2, index2) {
                    console.log(item2)
                })
            }
        }
    })

    const handleSubmit = (event, molecule1Info, molecule2Info) => {
        event.preventDefault()
        var molecule1InfoArray = molecule1Info.split("/")
        const id1 = molecule1InfoArray[0]
        const molecule1 = molecule1InfoArray[1]
        const type1 = molecule1InfoArray[2]

        var molecule2InfoArray = molecule2Info.split("/")
        const id2 = molecule2InfoArray[0]
        const molecule2 = molecule2InfoArray[1]
        const type2 = molecule2InfoArray[2]

        const values = {
            id1: Number(id1),
            type1: type1,
            id2: Number(id2),
            type2: type2
        }

        axios.post("http://127.0.0.1:8080/interactions/results/specific", {...values})
            .then((response) => {
                console.log(response)
                props.history.push('/interactions/results/specific', {response: response.data})
            })
            .catch((err) => {})
    }

    const deconstructData = () => {
        return (
            data.map(function (item, index) {
                return(
                    Object.entries(item).map(([molecule1, innerItem]) => {
                        return (
                            Object.entries(innerItem).map(([molecule2, interactionInfo]) => {
                                return (
                                    <div>
                                        <Button onClick={(e) => handleSubmit(e, molecule1, molecule2)} variant="contained" color="primary">
                                            {molecule1} --{">"} {deconstructArrayIntoString(interactionInfo)} {molecule2}
                                        </Button>
                                    </div>
                                )
                            }) 
                        )
                    })
                )
            })
        )
    }

    const deconstructArrayIntoString = (array) => {
        return (
            array.map(function (item, index) {
                return (item + " ")
            })
        )
    }

    return (
        <div class="App">
            <header>
                {deconstructData()}
            </header>
        </div>
    )
};

export default ResultPage;