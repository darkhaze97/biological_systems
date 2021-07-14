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

    if (data.length == 0) {
        return (
            <div class="App">
                <h1>
                    No matching information.
                </h1>
            </div>
        )
    }

    const handleSubmit = (event, entity1Info, entity2Info) => {
        event.preventDefault()
        var entity1InfoArray = entity1Info.split("/")
        const id1 = entity1InfoArray[0]
        const type1 = entity1InfoArray[2]

        var entity2InfoArray = entity2Info.split("/")
        const id2 = entity2InfoArray[0]
        const type2 = entity2InfoArray[2]

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
                    Object.entries(item).map(([entity1, innerItem]) => {
                        return (
                            Object.entries(innerItem).map(([entity2, interactionInfo]) => {
                                return (
                                    <div>
                                        <Button onClick={(e) => handleSubmit(e, entity1, entity2)} variant="contained" color="primary">
                                            {entity1} --{">"} {deconstructArrayIntoString(interactionInfo)} {entity2}
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