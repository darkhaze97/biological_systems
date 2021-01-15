import React from "react";


const SpecificResultPage = (props) => {
    const data = props.location.state.response
    console.log(data)

    const handleMolecule1 = () => {
        const molecule1 = data.molecule1
        return (
            <div>
                <h1>
                    {molecule1.name} ({molecule1.type})
                </h1>
                {Object.entries(molecule1).map(([infoColumn, info]) => {
                    return (
                        <div>
                            {infoColumn !== "name" && infoColumn !== "type" && 
                            (<h4>{infoColumn}: {info}</h4>)}
                        </div>
                    )
                })}
            </div>
        )
    }

    const handleMolecule2 = () => {
        const molecule2 = data.molecule2
        return (
            <div>
                <h1>
                    {molecule2.name} ({molecule2.type})
                </h1>
                {Object.entries(molecule2).map(([infoColumn, info]) => {
                    return (
                        <div>
                            {infoColumn !== "name" && infoColumn !== "type" && 
                            (<h4>{infoColumn}: {info}</h4>)}
                        </div>
                    )
                })}
            </div>
        )
    }

    const handleInteractions = () => {
        const interactions = data.interactions
        //Interactions looks something like:
        //{'Coding': {'name': 'Blah', 'info': {'info1': 'blah', 'info2': 'blah'}}}

        //The ternary operator is required below so that we can account for printing
        //either the 'name' or the 'info' values, which can be a string or an object.
        return (
            <div>
                <h1 class="test">
                    INTERACTIONS:
                </h1>
                {Object.entries(interactions).map(([infoColumn, info]) => {
                    return (
                        <div>
                            <h2>
                                Category: {infoColumn}
                            </h2>
                            {Object.entries(info).map(([attr, attrInfo]) => {
                                return(
                                    <div>
                                        {typeof attrInfo !== "object" ? 
                                            (
                                                <h4>
                                                    {attr}: {attrInfo}
                                                </h4>
                                            ) : (
                                                <div>
                                                    {Object.entries(attrInfo).map(([attr2, attr2Info]) => {
                                                        return (
                                                            <h4>
                                                                {attr2}: {attr2Info}
                                                            </h4>
                                                        )
                                                    })}
                                                </div>
                                            )
                                        }
                                    </div>
                                )
                            })}
                        </div>
                    )
                })}
            </div>
        )
    }

    return (
        <div class="component-padding">
            <div class="rowC">
                <p class="Interaction-border">
                    {handleMolecule1()}
                </p>
                <p class="Interaction-border">
                    {handleMolecule2()}
                </p>
            </div>
            <p class="Interaction-border">
                    {handleInteractions()}
            </p>
        </div>
    )
};

export default SpecificResultPage;


